# -*- coding: utf-8 -*-
"""
pipeline.py — 词库自动化最终版

功能总览：
- wordfreq 取词（支持 AUTO_OFFSET）
- LLM 生成基础 JSON（多词性 + 每个词性有对应中文释义；至少 1 个 phrase + AB 对话）
- JSON Schema 验证 + 质量检查（短语/对话宽松匹配；功能词豁免；覆盖率校验）
- 二次补救（专用 Prompt）
- 若仍失败：自动运行 auto_whitelist.py -> 重新加载白名单 -> 对失败词再补救一次
- 二次仍失败：写入 failed_permanent.json（单一文件，追加去重）并强制清理临时失败日志
- 成功时：清理所有失败日志
- 断点续跑：state.json 与运行配置绑定
- 例句：Tatoeba EN-ZH TSV，简体优先；口语评分选择
- IPA：CMUdict 美音
- 并发：可配置 WORKERS（合并/写入加锁）
"""

import os, re, json, time, shutil, glob, subprocess, threading, hashlib
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests
from tqdm import tqdm
from wordfreq import top_n_list
import cmudict
from jsonschema import validate
from opencc import OpenCC

# ===================== 基本配置（按需修改） =====================
TOTAL_WORDS     = 1000         # 本轮目标词数（优化：增加到1000词）
BATCH_SIZE      = 8            # 主批次大小（优化：降低到8以提高成功率）
MIN_BATCH_SIZE  = 3            # 自适应分片最小（优化：降低最小分片）
RETRY_BATCH_SIZE= 3            # 二次补救的小批量（优化：更小批次精确处理）
MAX_RETRY       = 2            # 主批内重试次数
RETRY_MAX_RETRY = 2            # 二次补救内重试次数（优化：快速失败避免无效重试）
TEMPERATURE     = 0.1
WORKERS         = 2            # 并发 worker 数（1=串行；2 更快；注意 API 限流）
TIMEOUT_SEC     = 90           # 请求超时（增加到90秒）

# 词区间（固定区间，避免重复获取）
AUTO_OFFSET     = False        # True: 自动用现有 words.json 的长度作为 OFFSET
OFFSET          = 3000         # Resource4处理3000-3999词汇

# 预判跳过：已存在的词是否跳过不请求 AI（省钱省时）
SKIP_EXISTING   = True

# 数据/文件
WORDS_REPO      = "words.json"
BACKUP_DIR      = "backup"
LOG_DIR         = "logs"
STATE_FILE      = "state.json"
TATO_FILE       = os.path.join("data", "tatoeba_en_zh.tsv")
PERM_FAILED_FILE= os.path.join("..", "Resource", "failed_permanent.json")     # 永久失败词（统一写入Resource目录）
FUNCTION_WORDS_FILE = "function_words_custom.txt"  # 外部自定义白名单

# DeepSeek
MODEL_NAME      = "glm-4.6"
DEEPSEEK_API_KEY = "sk-550080883bc649498b2f4897e5df2929"  # DeepSeek API Key

# 日志清理策略
LOG_CLEAN_ON_SUCCESS = True    # 本轮无失败 -> 清理所有失败日志
LOG_PRUNE_RESOLVED   = True    # 本轮仍有失败 -> 也清理那些“已被补齐”的历史失败日志
LOG_KEEP_LAST_RUNS   = 5       # run_*.log 保留最近 N 份

# =========== 多词性 + 每个词性有对应中文释义：Schema ===========
SCHEMA = {
    "type": "array",
    "items": {
        "type": "object",
        "required": ["word", "parts_of_speech", "pos_meanings", "phrases", "sentences", "pronunciation"],
        "properties": {
            "word": {"type": "string"},
            "parts_of_speech": {
                "type": "array",
                "items": {"type": "string"},
                "minItems": 1
            },
            # pos_meanings: [{pos:"verb", cn:"中文释义"}, ...]
            "pos_meanings": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["pos", "cn"],
                    "properties": {
                        "pos": {"type": "string"},
                        "cn":  {"type": "string"}
                    }
                },
                "minItems": 1
            },
            "phrases": {
                "type": "array",
                "items": {
                    "type": "object",
                    "required": ["phrase", "dialog"],
                    "properties": {
                        "phrase": {"type": "string"},
                        "dialog": {
                            "type": "object",
                            "required": ["A", "B"],
                            "properties": {
                                "A": {"type": "string"},
                                "B": {"type": "string"}
                            }
                        }
                    }
                },
                "minItems": 0
            },
            "sentences": {"type": "array"},  # 由脚本补齐
            "pronunciation": {
                "type": "object",
                "required": ["US"],
                "properties": {
                    "US": {
                        "type": "object",
                        "required": ["ipa", "audio"],
                        "properties": {
                            "ipa":   {"type": ["string", "null"]},
                            "audio": {"type": ["string", "null"]}
                        }
                    }
                }
            }
        }
    }
}

# ===================== 运行 ID（变配置则重置 state） =====================
def _load_repo_dict():
    if not os.path.exists(WORDS_REPO):
        return {}
    try:
        data = json.load(open(WORDS_REPO, "r", encoding="utf-8"))
        if not isinstance(data, list):
            return {}
        return { (it.get("word") or "").lower(): it for it in data if isinstance(it, dict) }
    except:
        return {}

def _save_repo(repo_dict: dict):
    os.makedirs(BACKUP_DIR, exist_ok=True)
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    # 备份
    with open(os.path.join(BACKUP_DIR, f"words_{ts}.json"), "w", encoding="utf-8") as bf:
        json.dump(list(repo_dict.values()), bf, ensure_ascii=False, indent=2)
    # 写主文件
    with open(WORDS_REPO, "w", encoding="utf-8") as f:
        json.dump(list(repo_dict.values()), f, ensure_ascii=False, indent=2)

def _count_repo(repo_dict): return len(repo_dict)

repo_lock  = threading.Lock()
state_lock = threading.Lock()

def _compute_offset(repo_dict):
    return _count_repo(repo_dict)

# run_id 绑定 offset/total/batch
def _run_id(offset, total, batch):
    return f"off{offset}-tot{total}-bs{batch}"

def batch_key(words):
    # 用词列表生成稳定 key（小写 + 逗号拼接）
    s = ",".join([w.lower() for w in words])
    return hashlib.sha1(s.encode("utf-8")).hexdigest()

def load_state(RUN_ID):
    if not os.path.exists(STATE_FILE):
        return {"run_id": RUN_ID, "done_batches": []}
    try:
        st = json.load(open(STATE_FILE, "r", encoding="utf-8"))
        old_run_id = st.get("run_id")
        if old_run_id != RUN_ID:
            print(f"🔄 参数变更：旧RUN_ID={old_run_id} -> 新RUN_ID={RUN_ID}，清空状态")
            return {"run_id": RUN_ID, "done_batches": []}
        st["done_batches"] = list(set(st.get("done_batches", [])))
        return st
    except:
        return {"run_id": RUN_ID, "done_batches": []}

def save_state(state, RUN_ID):
    state["run_id"] = RUN_ID
    with open(STATE_FILE, "w", encoding="utf-8") as f:
        json.dump(state, f, ensure_ascii=False, indent=2)

# ===================== 功能词白名单（外部文件 + 黑名单兜底） =====================
BASE_FUNCTION_WORDS = {
    "a","an","the","some","any","each","every","either","neither","another",
    "this","that","these","those","both","all","half","many","much","few","little",
    "i","you","he","she","it","we","they","me","him","her","us","them",
    "my","your","his","her","its","our","their","mine","yours","hers","ours","theirs",
    "someone","anyone","everyone","no one","something","anything","everything","nothing",
    "to","of","in","on","at","for","from","by","with","about","as","after","before",
    "between","around","since","than","over","under","into","onto","through","during",
    "without","within","across","against","toward","upon","off","up","down","out",
    "and","or","but","if","so","yet","nor","though","although","because","while","unless",
    "be","am","is","are","was","were","been","being",
    "do","does","did","done","doing",
    "have","has","had","having",
    "can","could","may","might","must","shall","should","will","would",
    "not","n't","no","only","very","just",
    "i'm","you're","he's","she's","it's","we're","they're",
    "i've","you've","we've","they've",
    "i'd","you'd","he'd","she'd","we'd","they'd",
    "i'll","you'll","he'll","she'll","we'll","they'll",
    "don't","doesn't","didn't","can't","couldn't","won't","wouldn't","isn't",
    "aren't","wasn't","weren't","haven't","hasn't","hadn't","shouldn't","mustn't",
}

CONTENT_BLACKLIST = {
    "help","find","show","make","take","give","get","go","come","look","work","call",
    "use","need","try","keep","think","know","feel","tell","ask","play","run","write",
    "people","person","thing","time","way","good","new","old","high","big","small",
    "better","best","always","never","end","begin","start"
}

def load_function_words():
    words = set(BASE_FUNCTION_WORDS)
    if os.path.exists(FUNCTION_WORDS_FILE):
        for line in open(FUNCTION_WORDS_FILE, "r", encoding="utf-8"):
            w = line.strip().lower()
            if not w: continue
            if w in CONTENT_BLACKLIST:  # 误加的实词不采纳
                continue
            words.add(w)
    return words

FUNCTION_WORDS = load_function_words()

# ===================== Prompt =====================
PROMPT_TEMPLATE = """
你要为我提供的英语单词生成一个严格的 JSON 数组（仅输出 JSON，无任何额外文字）。
每个元素对象必须包含：
- "word": 单词
- "parts_of_speech": 在 {noun, verb, adj, adv, pron, prep, conj, det, aux, modal, interj, num, proper_noun, abbr, article, phrasal_verb} 中选择合适的一个或多个
- "pos_meanings": 数组；每个元素形如 { "pos": "verb", "cn": "简短中文释义（≤30字）" }。
  要求：列出的 pos 与 parts_of_speech 一一对应，每个 pos 必须有且仅有一个简短中文释义。
- "phrases": 数组：
- 非功能词（名/动/形/副等）：至少 1 个对象，短语须为自然搭配，不能等于单词本体
- 功能词（冠词/代词/介词/连词/助动/情态/感叹/数词等）：允许为空 []
  [
    {
      "phrase": "包含该单词本体的常见词组（如 help out / find out / show up / deal with）",
      "dialog": { "A": "一句自然口语，≤12词", "B": "自然回复，≤12词" }
    }
  ]
- "sentences": 固定为 []
- "pronunciation": 固定为 { "US": { "ipa": null, "audio": null } }

严格要求：
1) 只返回 JSON 数组；长度必须与我提供的单词数一致。
2) phrases.dialog 的 A 或 B 必须逐字包含 phrases.phrase；不得用单词本体充当短语。
3) 输出精简：每个中文释义 ≤ 30 字；对话口语自然，避免同义替换导致短语缺失。
4) word 字段必须与输入单词完全一致（包含大小写与撇号），不得改写或规范化。
单词列表（逗号分隔）：
<<WORDS>>
""".strip()

RESCUE_PROMPT_TEMPLATE = """
为我提供的英语单词生成严格格式的 JSON 数组（仅输出 JSON）。
每个对象必须严格按照以下格式：
{
  "word": "单词",
  "parts_of_speech": ["noun", "verb"],
  "pos_meanings": [
    {"pos": "noun", "cn": "名词释义≤30字"},
    {"pos": "verb", "cn": "动词释义≤30字"}
  ],
  "phrases": [
    {
      "phrase": "真实的短语词组（如make up/look at/find out，绝对不能是单词本体）",
      "dialog": {
        "A": "自然对话≤12词包含短语",
        "B": "回复≤12词"
      }
    }
  ],
  "sentences": [],
  "pronunciation": {"US": {"ipa": null, "audio": null}}
}

重要规则：
1. pos_meanings必须是对象数组，每个元素包含pos和cn两个字段！
2. phrase绝对不能是单词本体！必须是真实的短语词组！
3. 如果找不到合适的短语，phrases可以为空数组 []
只输出JSON数组，长度与输入单词数一致。

单词列表：
<<WORDS>>
""".strip()

# 功能词专用简化模板（给功能词一个极简但合规的短语与对话）
FUNCTION_WORD_PROMPT_TEMPLATE = """
为我提供的功能词生成简化的 JSON 数组（仅输出 JSON）。
功能词（冠词/代词/介词/连词/助动词/情态动词等）要求：
- "word": 单词
- "parts_of_speech": 从 {det, pron, prep, conj, aux, modal, interj, num} 中选择合适的一个或多个
- "pos_meanings": 数组；每个元素形如 { "pos": "prep", "cn": "简短中文释义（≤20字）" }
- "phrases": 功能词很难构成独立短语，通常为空数组 []
- "sentences": 固定为 []
- "pronunciation": 固定为 { "US": { "ipa": null, "audio": null } }

重要规则：
1. pos_meanings必须是对象数组格式！
2. 绝对不能用单词本体作为phrase！
3. 功能词phrases通常为空 []

只返回 JSON 数组，长度与输入单词数一致。

单词列表：
<<WORDS>>
""".strip()

def build_prompt(batch_words):         
    # 智能选择模板：如果批次中功能词占多数，使用功能词模板
    function_word_count = sum(1 for w in batch_words if w.lower() in FUNCTION_WORDS)
    if function_word_count >= len(batch_words) * 0.5:  # 50%以上是功能词
        return FUNCTION_WORD_PROMPT_TEMPLATE.replace("<<WORDS>>", ", ".join(batch_words))
    else:
        return PROMPT_TEMPLATE.replace("<<WORDS>>", ", ".join(batch_words))

def build_rescue_prompt(batch_words):  return RESCUE_PROMPT_TEMPLATE.replace("<<WORDS>>", ", ".join(batch_words))

# ===================== DeepSeek 调用 =====================
def call_glm(prompt: str):
    if not DEEPSEEK_API_KEY:
        raise RuntimeError("DEEPSEEK_API_KEY 未设置")
    url = "https://api.deepseek.com/v1/chat/completions"
    headers = {"Authorization": f"Bearer {DEEPSEEK_API_KEY}", "Content-Type": "application/json"}
    payload = {
        "model": MODEL_NAME,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": TEMPERATURE,
        "stream": False
    }
    print(f"→ 调用AI：{len(prompt)} chars | 模型={MODEL_NAME}", flush=True)
    resp = requests.post(url, headers=headers, json=payload, timeout=TIMEOUT_SEC)
    print("AI returned, parsing...", flush=True)
    resp.raise_for_status()
    data = resp.json()
    content = data["choices"][0]["message"]["content"]
    return content

def extract_json_block(raw: str):
    # 尽量提取 JSON；若已是array或object，直接返回
    s = raw.strip()
    if s.startswith("{") or s.startswith("["):
        return s
    # 简单清洗
    l = s.find("["); r = s.rfind("]")
    if l != -1 and r != -1 and r > l:
        return s[l:r+1]
    raise ValueError("未找到 JSON 数组")

# ===================== 短语匹配：严格 + 宽松（允许插词） =====================
_WORD_RE = re.compile(r"[A-Za-z]+(?:'[A-Za-z]+)?")

def _tokenize_words(text: str):
    return _WORD_RE.findall(text.lower())

def phrase_in_text_exact(phrase: str, text: str) -> bool:
    p = re.escape(phrase).replace("\\ ", r"\s+")
    pattern = rf"(^|[\s\"'“”‘’(),.;:!?-]){p}($|[\s\"'“”‘’(),.;:!?-])"
    return re.search(pattern, text, flags=re.IGNORECASE) is not None

def phrase_in_text_loose(phrase: str, text: str, max_gap: int = 2) -> bool:
    ph = phrase.strip().lower()
    if not ph: return False
    words = ph.split()
    if len(words) == 1:
        return phrase_in_text_exact(phrase, text)
    tw = _tokenize_words(text)
    n, m = len(tw), len(words)
    if n == 0: return False
    first = words[0]
    for i in range(n):
        if tw[i] != first: continue
        pos = i; ok = True
        for j in range(1, m):
            target = words[j]; found = False
            upper = min(n, pos + 1 + max_gap + 1)
            for k in range(pos + 1, upper):
                if tw[k] == target:
                    pos = k; found = True; break
            if not found: ok = False; break
        if ok: return True
    return False

def phrase_in_text(phrase: str, text: str) -> bool:
    return phrase_in_text_exact(phrase, text) or phrase_in_text_loose(phrase, text, max_gap=2)

# ===================== 质量检查 =====================
# 允许的标准 POS 标签
ALLOWED_POS = {
    "noun","verb","adj","adv","pron","prep","conj","det",
    "aux","modal","interj","num","proper_noun","abbr","article","phrasal_verb"
}

# 常见别名映射到标准标签
POS_MAP = {
    "n":"noun","v":"verb","a":"adj","adjective":"adj","adverb":"adv",
    "pronoun":"pron","preposition":"prep","conjunction":"conj","determiner":"det","article":"det","art":"det",
    "auxiliary":"aux","aux":"aux","modal verb":"modal","modal":"modal",
    "interjection":"interj","number":"num","numeral":"num",
    "proper noun":"proper_noun","proper-noun":"proper_noun",
    "phrasal verb":"phrasal_verb","phrasal-verb":"phrasal_verb"
}

def _canon_pos(p: str):
    if not p: return None
    p = (p or "").strip().lower()
    # 先按常见分隔切开，逐个映射，取第一个可识别的
    parts = re.split(r"[\/,\s\-]+", p)
    for part in parts:
        cand = POS_MAP.get(part, part)
        if cand in ALLOWED_POS:
            return cand
    return None

def _normalize_pos_list(pos_list):
    out = []
    for p in pos_list:
        cp = _canon_pos(p)
        if cp and cp in ALLOWED_POS and cp not in out:
            out.append(cp)
    return out

def _normalize_pos_meanings(pos_meanings):
    out = []
    for it in pos_meanings:
        if not isinstance(it, dict): continue
        pos = _canon_pos(it.get("pos"))
        cn  = (it.get("cn") or "").strip()
        if pos and pos in ALLOWED_POS and cn:
            out.append({"pos": pos, "cn": cn})
    return out

def check_pos_alignment(item):
    """确保 parts_of_speech 与 pos_meanings 一一对应"""
    pos_list = _normalize_pos_list(item.get("parts_of_speech", []))
    pm_list  = _normalize_pos_meanings(item.get("pos_meanings", []))
    if not pos_list or not pm_list:
        return False, "pos-empty"
    pos_set = set(pos_list)
    pm_pos  = {x["pos"] for x in pm_list}
    if pos_set != pm_pos:
        return False, f"pos-mismatch: pos={sorted(pos_set)} pm={sorted(pm_pos)}"
    return True, ""

def quality_checks(items):
    bad = []
    for it in items:
        w = (it.get("word") or "").lower().strip() or "?"
        
        # === 功能词豁免：只需基本pos检查，无需phrase/dialog ===
        if w in FUNCTION_WORDS:
            # 对功能词使用宽松的pos检查
            pos_list = _normalize_pos_list(it.get("parts_of_speech", []))
            pm_list  = _normalize_pos_meanings(it.get("pos_meanings", []))
            # 功能词只要有任何pos信息就通过
            if not pos_list and not pm_list:
                bad.append((w, "function-word-pos-empty")); continue
            # 功能词不要求pos与pos_meanings严格对齐，只要不为空即可
            continue
        
        # 1) 非功能词的严格pos对齐检查
        ok, reason = check_pos_alignment(it)
        if not ok:
            bad.append((w, reason)); continue

        phr = it.get("phrases", [])

        # 非功能词允许空phrases（当找不到合适真实短语时）
        # 如果有phrases，则必须是真实短语，不能是单词本体

        # 2) phrase 必须在 A/B 出现（宽松）；或至少 word 本体出现
        ok_all = True
        for p in phr:
            phrase = (p.get("phrase") or "").strip()
            d = p.get("dialog", {}) or {}
            A = (d.get("A") or "").strip()
            B = (d.get("B") or "").strip()
            if not phrase or not A or not B:
                ok_all = False; break
                # 不能用单词本体充当短语
            if phrase.strip().lower() == w:
                ok_all = False; break
            # 只认短语命中
            hit_phrase = phrase_in_text(phrase, A) or phrase_in_text(phrase, B)
            if not hit_phrase:
                ok_all = False; break
            if len(A.split()) > 20 or len(B.split()) > 20:
                ok_all = False; break
        if not ok_all:
            bad.append((w, "dialog-loose-mismatch"))
    return bad

def check_coverage(expected_words, items):
    exp = [x.lower() for x in expected_words]
    got = [ (it.get("word") or "").lower() for it in items ]
    missing = sorted(set(exp) - set(got))
    extras  = sorted(set(got) - set(exp))
    dupes   = sorted([w for w in got if got.count(w) > 1])
    return (len(missing)==0 and len(extras)==0), {"missing":missing,"extras":extras,"dupes":dupes}

# ===================== 例句（Tatoeba）& IPA =====================
cc = OpenCC('t2s')  # 转简体
def _score_cn_colloquial(s):
    s0 = cc.convert(s)
    score = 0
    if any(x in s0 for x in "吧啊嘛呢呀哈啦咯呀呗挺蛮嘛吧呀呢"): score += 2
    if any(x in s0 for x in "你我他她咱"): score += 1
    if any(x in s0 for x in "之者若於矣焉"): score -= 2
    if "！" in s0 or "!" in s0: score += 1  # 口语感
    L = len(s0)
    if L < 4 or L > 28: score -= 1
    return score, s0

def load_tatoeba(path=TATO_FILE, limit_per_word=2):
    """读取 TSV: EN \t ZH ... ; 返回 {en: [zh1, zh2...]}"""
    if not os.path.exists(path):
        return {}
    out = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            parts = line.rstrip("\n").split("\t")
            if len(parts) < 4: 
                # 兼容 2 列 EN\tZH
                if len(parts) == 2:
                    en, zh = parts
                else:
                    continue
            else:
                _, en, _, zh = parts[0], parts[1], parts[2], parts[3]
            en_key = en.strip()
            zh_sc  = cc.convert(zh.strip())
            out.setdefault(en_key, []).append(zh_sc)
    # 为每个 EN 选前 limit_per_word 个口语感更强的
    sel = {}
    for en, arr in out.items():
        arr2 = sorted(arr, key=lambda s: _score_cn_colloquial(s), reverse=True)
        sel[en] = arr2[:limit_per_word]
    return sel

TATO = load_tatoeba()

def enrich_with_ipa_and_sentences(items):
    # ARPABET到IPA转换映射表
    arpabet_to_ipa = {
        'AA': 'ɑ',   'AE': 'æ',   'AH': 'ʌ',   'AO': 'ɔ',   'AW': 'aʊ',  'AY': 'aɪ',
        'B':  'b',   'CH': 'tʃ',  'D':  'd',   'DH': 'ð',   'EH': 'ɛ',   'ER': 'ɝ',
        'EY': 'eɪ',  'F':  'f',   'G':  'g',   'HH': 'h',   'IH': 'ɪ',   'IY': 'iː',
        'JH': 'dʒ',  'K':  'k',   'L':  'l',   'M':  'm',   'N':  'n',   'NG': 'ŋ',
        'OW': 'oʊ',  'OY': 'ɔɪ',  'P':  'p',   'R':  'r',   'S':  's',   'SH': 'ʃ',
        'T':  't',   'TH': 'θ',   'UH': 'ʊ',   'UW': 'uː',  'V':  'v',   'W':  'w',
        'Y':  'j',   'Z':  'z',   'ZH': 'ʒ'
    }
    
    d = cmudict.dict()
    for it in items:
        w = (it.get("word") or "").lower()
        phones = d.get(w)
        ipa = None
        if phones:
            # 转换ARPABET到IPA
            seq = phones[0]  # 取第一个发音
            ipa_symbols = []
            primary_stress_pos = -1
            secondary_stress_pos = -1
            
            # 找到重音位置
            for i, phone in enumerate(seq):
                if '1' in phone:  # 主重音
                    primary_stress_pos = i
                elif '2' in phone:  # 次重音
                    secondary_stress_pos = i
            
            # 转换音素并添加重音标记
            for i, phone in enumerate(seq):
                clean_phone = re.sub(r'\d', '', phone)  # 去掉数字
                if clean_phone in arpabet_to_ipa:
                    # 添加重音符号
                    if i == primary_stress_pos:
                        ipa_symbols.append('ˈ' + arpabet_to_ipa[clean_phone])
                    elif i == secondary_stress_pos:
                        ipa_symbols.append('ˌ' + arpabet_to_ipa[clean_phone])
                    else:
                        ipa_symbols.append(arpabet_to_ipa[clean_phone])
                else:
                    # 未知音素，保持原样但去掉数字
                    if i == primary_stress_pos:
                        ipa_symbols.append('ˈ' + clean_phone)
                    elif i == secondary_stress_pos:
                        ipa_symbols.append('ˌ' + clean_phone)
                    else:
                        ipa_symbols.append(clean_phone)
            
            ipa = "/" + "".join(ipa_symbols) + "/"
        
        it.setdefault("pronunciation", {}).setdefault("US", {})
        it["pronunciation"]["US"]["ipa"] = ipa
        it["pronunciation"]["US"]["audio"] = None

        # Tatoeba 例句：简单用该词的英文匹配
        sents = []
        for en, zhs in TATO.items():
            if re.search(rf"(^|[^A-Za-z]){re.escape(w)}([^A-Za-z]|$)", en, flags=re.I):
                for zh in zhs:
                    sents.append({"en": en, "zh": zh})
                if len(sents) >= 2:
                    break
        it["sentences"] = sents

# ===================== 取词 & 批次 =====================
def get_word_slice(offset, total, repo_dict):
    if not SKIP_EXISTING:
        # 如果不跳过已存在的，保持原逻辑
        words_all = top_n_list("en", offset + total + 100)
        return words_all[offset : offset + total]
    
    # 智能取词：保证取到 total 个新词
    new_words = []
    current_offset = offset
    batch_size = total * 3  # 初始批量，预估需要3倍词量
    
    while len(new_words) < total:
        # 取更多词防止不够
        words_all = top_n_list("en", current_offset + batch_size)
        
        # 从当前位置开始找新词
        found_new = 0
        for i in range(current_offset, min(len(words_all), current_offset + batch_size)):
            word = words_all[i]
            if word.lower() not in repo_dict:
                new_words.append(word)
                found_new += 1
                if len(new_words) >= total:
                    break
        
        current_offset += batch_size
        
        # 如果这批没找到新词且已经超出词典范围，停止
        if found_new == 0 and current_offset >= len(words_all):
            print(f"⚠️  警告：wordfreq词典中只找到 {len(new_words)} 个新词，少于目标 {total} 个")
            break
    
    return new_words[:total]  # 确保不超过目标数量

def split_batches(words, batch_size):
    return [words[i:i+batch_size] for i in range(0, len(words), batch_size)]

# ===================== 智能重试机制 =====================
def create_smart_retry_prompt(batch_words, error_reason):
    """根据失败原因创建智能重试Prompt"""
    
    # 所有分支统一使用这个基础模板，确保格式一致
    base_template = f"""
为以下英语单词生成严格格式的 JSON 数组（仅输出 JSON）：
[
  {{
    "word": "单词",
    "parts_of_speech": ["noun"],
    "pos_meanings": [
      {{"pos": "noun", "cn": "中文释义"}}
    ],
    "phrases": [],
    "sentences": [],
    "pronunciation": {{"US": {{"ipa": null, "audio": null}}}}
  }}
]

关键规则：
1. pos_meanings必须是对象数组，每个元素包含pos和cn字段！
2. 绝对不能用单词本体作为phrase！
3. 如果找不到合适的真实短语，phrases为空数组 []
4. 输出数组长度必须等于输入词数

单词：{', '.join(batch_words)}
"""
    
    return base_template.strip()

def smart_retry_batch(repo_dict, batch_words, error_reason, max_smart_retry=2):
    """智能重试：针对特定失败类型的专门处理"""
    for smart_attempt in range(max_smart_retry):
        try:
            smart_prompt = create_smart_retry_prompt(batch_words, error_reason)
            raw = call_glm(smart_prompt)
            data = json.loads(extract_json_block(raw))
            validate(instance=data, schema=SCHEMA)
            
            # 使用宽松质量检查
            bad = quality_checks(data)
            if bad:
                continue  # 仍有问题，继续智能重试
                
            ok, diff = check_coverage(batch_words, [it for it in data])
            if not ok:
                continue  # 覆盖率问题，继续重试
            
            # 成功：合并数据
            with repo_lock:
                added = updated = 0
                for it in data:
                    w = (it.get("word") or "").lower()
                    if w in repo_dict: updated += 1
                    else: added += 1
                    repo_dict[w] = it
                _save_repo(repo_dict)
            return True, added, updated, len(batch_words), ""
            
        except Exception as e:
            continue  # 继续尝试
    
    return False, 0, 0, len(batch_words), f"smart-retry-failed after {max_smart_retry} attempts"

# ===================== 执行一批 =====================
def run_batch(repo_dict, batch_words, max_retry, prompt_builder, prompt_override=None):
    last_err = ""
    validation_errors = 0  # 连续ValidationError计数
    
    for attempt in range(max_retry + 1):
        try:
            prompt = prompt_override or prompt_builder(batch_words)
            raw = call_glm(prompt)
            data = json.loads(extract_json_block(raw))
            validate(instance=data, schema=SCHEMA)

            # 统一化 pos/pos_meanings
            for it in data:
                it["parts_of_speech"] = _normalize_pos_list(it.get("parts_of_speech", []))
                it["pos_meanings"]    = _normalize_pos_meanings(it.get("pos_meanings", []))

            bad = quality_checks(data)
            if bad:
                raise ValueError(f"质量检查不通过 {len(bad)} 条（示例）: {bad[:5]}")
            ok, diff = check_coverage(batch_words, [it for it in data])
            if not ok:
                raise ValueError(f"覆盖率失败: 缺 {len(diff['missing'])}, 多 {len(diff['extras'])}, 重复 {len(diff['dupes'])}")

            # 合并 + 落盘（加锁）
            with repo_lock:
                added = updated = 0
                for it in data:
                    w = (it.get("word") or "").lower()
                    if w in repo_dict: updated += 1
                    else: added += 1
                    repo_dict[w] = it
                _save_repo(repo_dict)
            return True, added, updated, len(batch_words), ""
        except Exception as e:
            last_err = repr(e)
            print("DEBUG_FAIL_SAMPLE:", last_err, flush=True)
            
            # ValidationError快速失败机制
            if "ValidationError" in last_err:
                validation_errors += 1
                if validation_errors >= 2:  # 连续2次ValidationError就快速失败
                    print(f"❌ 连续{validation_errors}次ValidationError，快速失败避免无效重试")
                    break
            else:
                validation_errors = 0  # 重置计数器
            
            time.sleep(1.0)
    
    # 常规重试失败后，尝试智能重试
    print(f"启动智能重试，错误：{last_err}")
    smart_ok, smart_add, smart_upd, smart_used, smart_reason = smart_retry_batch(
        repo_dict, batch_words, last_err or "unknown-error"
    )
    if smart_ok:
        print(f"✅ 智能重试成功 | 新增 {smart_add} | 更新 {smart_upd}")
        return True, smart_add, smart_upd, smart_used, ""
    
    return False, 0, 0, len(batch_words), f"failed-after-smart-retry: {smart_reason}"

def run_batch_adaptive(repo_dict, words, max_retry, prompt_builder):
    """
    逐步处理整批 words：
    - 先尝试大块，失败就减半
    - 一旦某个子块成功，向前推进 start 指针，继续处理剩余尾部
    - 返回的 used 一定等于 len(words)（保证整批都被尝试过）
    """
    n = len(words)
    start = 0
    added_total = 0
    updated_total = 0
    last_reason = ""
    while start < n:
        # 当前剩余区间
        remain = n - start
        size = min(remain, max(MIN_BATCH_SIZE, remain))  # 从当前剩余的全量开始试
        ok_sub = False
        # 自适应缩小块
        while size >= MIN_BATCH_SIZE:
            ok, add, upd, _, reason = run_batch(repo_dict, words[start:start+size], max_retry, prompt_builder)
            if ok:
                added_total += add
                updated_total += upd
                start += size
                ok_sub = True
                break
            else:
                last_reason = reason
                size //= 2
        if not ok_sub:
            # 当前剩余这块在最小分片仍失败，放弃本批剩余
            return False, added_total, updated_total, n, "adaptive-failed"
    return True, added_total, updated_total, n, ""

# ===================== 日志工具 =====================
def prune_run_logs(keep_last=LOG_KEEP_LAST_RUNS):
    if not os.path.isdir(LOG_DIR): return
    runs = sorted(glob.glob(os.path.join(LOG_DIR, "run_*.log")))
    if len(runs) > keep_last:
        for p in runs[:-keep_last]:
            try: os.remove(p)
            except: pass

def _read_failed_words_from_txt(path):
    try:
        return {w.strip().lower() for w in open(path, "r", encoding="utf-8") if w.strip()}
    except:
        return set()

def _read_failed_words_from_json(path):
    try:
        data = json.load(open(path, "r", encoding="utf-8"))
        words = set()
        if isinstance(data, list):
            for b in data:
                words.update([w.lower() for w in b.get("words", [])])
        elif isinstance(data, dict):
            for b in data.get("failed", []):
                words.update([w.lower() for w in b.get("words", [])])
        return words
    except:
        return set()

def cleanup_logs(repo_dict, clean_all_if_success=False, prune_resolved=True):
    deleted = []
    if not os.path.isdir(LOG_DIR):
        return deleted
    if clean_all_if_success:
        for pat in ("failed_words_*.txt", "failed_batches_*.json"):
            for p in glob.glob(os.path.join(LOG_DIR, pat)):
                try: os.remove(p); deleted.append(os.path.basename(p))
                except: pass
        return deleted
    if prune_resolved:
        present = set(repo_dict.keys())
        for p in glob.glob(os.path.join(LOG_DIR, "failed_words_*.txt")):
            words = _read_failed_words_from_txt(p)
            if words and words.issubset(present):
                try: os.remove(p); deleted.append(os.path.basename(p))
                except: pass
        for p in glob.glob(os.path.join(LOG_DIR, "failed_batches_*.json")):
            words = _read_failed_words_from_json(p)
            if words and words.issubset(present):
                try: os.remove(p); deleted.append(os.path.basename(p))
                except: pass
    return deleted

# ===================== 主流程 =====================
def main():
    os.makedirs(LOG_DIR, exist_ok=True)

    # 读取仓库
    repo_dict = _load_repo_dict()
    initial_total = _count_repo(repo_dict)  # 记录运行前词库大小

    # 自动 OFFSET
    real_offset = _compute_offset(repo_dict) if AUTO_OFFSET else OFFSET
    RUN_ID = _run_id(real_offset, TOTAL_WORDS, BATCH_SIZE)
    state = load_state(RUN_ID)
    done_batches = set(state.get("done_batches", []))  # 现在里面放的是 key 字符串

    # 网络自检（不影响流程）
    try:
        r = requests.get("https://api.deepseek.com/v1/models",
                         headers={"Authorization": f"Bearer {DEEPSEEK_API_KEY}"},
                         timeout=10)
        print(f"网络自检：{r.status_code}（200/401/403视为连通）")
    except Exception as e:
        print(f"网络自检失败：{repr(e)}")

    # 取词 & 批次
    todo_words = get_word_slice(real_offset, TOTAL_WORDS, repo_dict)
    batches = split_batches(todo_words, BATCH_SIZE)
    total_batches = len(batches)
    print(f"计划处理：TOTAL_WORDS={TOTAL_WORDS}, BATCH_SIZE={BATCH_SIZE}, OFFSET={real_offset}（实际要请求 {len(todo_words)} 词）")

    added_total = updated_total = 0
    failed_batches = []
    RUN_TS = datetime.now().strftime("%Y%m%d_%H%M%S")

    prog = tqdm(total=total_batches, desc="主批次")
    # 并发执行
    def submit_job(ex, key, idx, words):
        def job():
            ok, add, upd, used, reason = run_batch_adaptive(repo_dict, words, MAX_RETRY, build_prompt)
            with state_lock:
                if ok:
                    nonlocal added_total, updated_total
                    added_total += add; updated_total += upd
                    done_batches.add(key)
                    state["done_batches"] = sorted(list(done_batches))
                    save_state(state, RUN_ID)
            return (idx, ok, add, upd, used, reason)
        return ex.submit(job)

    with ThreadPoolExecutor(max_workers=WORKERS) as ex:
        futures = []
        for i, batch_words in enumerate(batches, 1):
            key = batch_key(batch_words)
            if key in done_batches:
                prog.update(1); continue
            futures.append(submit_job(ex, key, i, batch_words))  # 传 key

        for fut in as_completed(futures):
            i, ok, add, upd, used, reason = fut.result()
            if ok:
                print(f"SUCCESS batch {i}/{total_batches} | used {used} | added {add} | updated {upd} | total {_count_repo(repo_dict)}")
                prog.set_postfix({"total_words": _count_repo(repo_dict), "status": "ok"})
            else:
                print(f"FAILED batch {i}/{total_batches} (adaptive failed). Reason: {reason}")
                failed_batches.append({"words": batches[i-1], "reason": reason})
                prog.set_postfix({"total_words": _count_repo(repo_dict), "status": "fail"})
            prog.update(1)
    prog.close()

    # 二次补救（对失败批各自再跑一次）
    final_failed_words = []
    if failed_batches:
        print(f"🛠 二次补救：{len(failed_batches)} 批，小批量 {RETRY_BATCH_SIZE}")
        rbatches = [b["words"] for b in failed_batches]
        prog2 = tqdm(total=len(rbatches), desc="补救批次")
        for i, r_words in enumerate(rbatches, 1):
            # 按小批切分
            chunks = split_batches(r_words, RETRY_BATCH_SIZE)
            ok_all = True
            for seg in chunks:
                ok, add, upd, used, reason = run_batch_adaptive(repo_dict, seg, RETRY_MAX_RETRY, build_rescue_prompt)
                if ok:
                    print(f"✅ 补救批 {i}/{len(rbatches)} | 新增 {add} | 更新 {upd} | 总 {_count_repo(repo_dict)}")
                else:
                    print(f"❌ 补救批 {i}/{len(rbatches)} 仍失败。原因：{reason}")
                    ok_all = False
            if not ok_all:
                final_failed_words.extend(r_words)
            prog2.update(1)
        prog2.close()

    # 写失败日志（仅当确有失败）
    if failed_batches:
        with open(os.path.join(LOG_DIR, f"failed_batches_{RUN_TS}.json"), "w", encoding="utf-8") as f:
            json.dump(failed_batches, f, ensure_ascii=False, indent=2)
    if final_failed_words:
        with open(os.path.join(LOG_DIR, f"failed_words_{RUN_TS}.txt"), "w", encoding="utf-8") as f:
            f.write("\n".join(sorted(set(final_failed_words))))

    # —— 自动执行 auto_whitelist.py + 重新补救一次（仅针对上一步还失败的词）——
    second_round_failed = []
    if final_failed_words:
        print("🤖 触发自动豁免：运行 auto_whitelist.py ……")
        try:
            subprocess.run(["python", "auto_whitelist.py"], check=False)
        except Exception as e:
            print(f"自动豁免脚本执行失败（忽略继续）：{repr(e)}")
        # 重新加载白名单
        global FUNCTION_WORDS
        FUNCTION_WORDS = load_function_words()
        # 仅对“还失败的词”再补救一轮
        print("🛠 自动豁免后再次补救失败词……")
        left = sorted(set([w.lower() for w in final_failed_words]))
        chunks = split_batches(left, min(RETRY_BATCH_SIZE, 5))
        for i, seg in enumerate(chunks, 1):
            ok, add, upd, used, reason = run_batch_adaptive(repo_dict, seg, RETRY_MAX_RETRY, build_rescue_prompt)
            if ok:
                print(f"✅ 二次后补救 {i}/{len(chunks)} | 新增 {add} | 更新 {upd}")
            else:
                print(f"❌ 二次后仍失败 {i}/{len(chunks)}：{reason}")
                second_round_failed.extend(seg)

    # 注意：此时还没有second_round_failed数据，将在后面计算最终统计
    
    # 二次后仍失败 → 写入永久失败文件，并强制清理临时失败日志
    if second_round_failed:
        print(f"📌 二次后仍失败 {len(second_round_failed)} 个，写入 {PERM_FAILED_FILE} 并清理临时失败日志")
        # 合并到永久文件（去重）
        exist = set()
        if os.path.exists(PERM_FAILED_FILE):
            try:
                exist = set(json.load(open(PERM_FAILED_FILE, "r", encoding="utf-8")))
            except:
                exist = set()
        merged = sorted(exist.union({w.lower() for w in second_round_failed}))
        with open(PERM_FAILED_FILE, "w", encoding="utf-8") as pf:
            json.dump(merged, pf, ensure_ascii=False, indent=2)
        # 强制清理临时失败日志
        for pat in ("failed_words_*.txt", "failed_batches_*.json"):
            for p in glob.glob(os.path.join(LOG_DIR, pat)):
                try: os.remove(p)
                except: pass
        final_failed_words = []  # 视为已处理（转入永久清单）
        failed_batches = []

    # 补齐 IPA & 例句
    print("🔧 正在补齐 IPA 与 例句...")
    all_items = list(repo_dict.values())
    enrich_with_ipa_and_sentences(all_items)
    # 合并落盘
    with repo_lock:
        for it in all_items:
            repo_dict[(it.get("word") or "").lower()] = it
        _save_repo(repo_dict)

    # 运行总结（计算最终准确统计）
    current_total = _count_repo(repo_dict)
    net_added = current_total - initial_total  # 净增长（真实的词库增长）
    
    stats_failed_batches_count = len([b for b in failed_batches])
    stats_final_failed_words_count = len(final_failed_words) 
    stats_second_round_failed_count = len(second_round_failed)
    
    # 总失败词数 = 最终写入永久失败文件的词数（避免重复计算）
    total_failed_words = stats_second_round_failed_count
    
    summary = (f"🎯 目标 {TOTAL_WORDS} 词 | 主批 {total_batches} | 失败主批 {stats_failed_batches_count} | "
               f"失败词 {total_failed_words} | 永久失败 {stats_second_round_failed_count} | "
               f"操作 {added_total}新增+{updated_total}更新 | 净增 {net_added} | 词库总数 {current_total}")
    print(summary)

    # 写 run 概览日志
    with open(os.path.join(LOG_DIR, f"run_{RUN_TS}.log"), "w", encoding="utf-8") as lf:
        lf.write(summary + "\n")

    # 智能清理（基于真实的失败情况判断）
    is_complete_success = (stats_failed_batches_count == 0) and (total_failed_words == 0)
    if is_complete_success:
        if LOG_CLEAN_ON_SUCCESS:
            removed = cleanup_logs(repo_dict, clean_all_if_success=True, prune_resolved=False)
            if removed: print(f"🧹 已清理历史失败日志：{removed}")
    else:
        if LOG_PRUNE_RESOLVED:
            removed = cleanup_logs(repo_dict, clean_all_if_success=False, prune_resolved=True)
            if removed: print(f"🧹 已清理已补齐的失败日志：{removed}")

    prune_run_logs()

if __name__ == "__main__":
    main()
