# auto_whitelist.py
# 从 logs/failed_batches_*.json 读取最近一次失败记录，
# 自动将符合条件的功能词加入 function_words_custom.txt
# 保留黑名单：help/find/show… 永远不会豁免

import os, glob, json, re

FUNCTION_WORDS_FILE = "function_words_custom.txt"

# 功能词候选（冠词/介词/连词/助动/情态/缩写/否定…）
CLOSED_CLASS = {
    # 冠词/限定词
    "a","an","the","some","any","each","every","either","neither","another",
    "this","that","these","those","both","all","half","many","much","few","little",
    "several","most","more","less","such","same","other","others",
    
    # 代词
    "i","you","he","she","it","we","they","me","him","her","us","them",
    "my","your","his","her","its","our","their","mine","yours","hers","ours","theirs",
    "someone","anyone","everyone","no one","something","anything","everything","nothing",
    "somebody","anybody","everybody","nobody","somewhere","anywhere","everywhere","nowhere",
    "myself","yourself","himself","herself","itself","ourselves","yourselves","themselves",
    "who","whom","whose","which","what","that","where","when","why","how",
    
    # 介词
    "to","of","in","on","at","for","from","by","with","about","as","after","before",
    "between","around","since","than","over","under","into","onto","through","during",
    "without","within","across","against","toward","towards","upon","off","up","down","out",
    "above","below","behind","beside","besides","beyond","near","next","inside","outside",
    
    # 连词
    "and","or","but","if","so","yet","nor","though","although","because","while","unless",
    "when","where","since","until","till","once","whenever","wherever","however","whatever",
    "whether","either","neither","both","not only","as well as",
    
    # 助动词/be动词
    "be","am","is","are","was","were","been","being",
    "do","does","did","done","doing",
    "have","has","had","having",
    
    # 情态动词
    "can","could","may","might","must","shall","should","will","would",
    "ought","need","dare","used",
    
    # 副词/修饰词
    "not","n't","no","only","very","just","quite","rather","too","enough",
    "also","even","still","already","yet","again","once","twice","often","always","never",
    "here","there","now","then","today","tomorrow","yesterday","soon","already",
    
    # 常见缩写
    "i'm","you're","he's","she's","it's","we're","they're","that's","who's","what's",
    "i've","you've","we've","they've","i'd","you'd","he'd","she'd","we'd","they'd",
    "i'll","you'll","he'll","she'll","we'll","they'll","won't","can't","don't","doesn't",
    "didn't","couldn't","wouldn't","shouldn't","mustn't","isn't","aren't","wasn't","weren't",
    "haven't","hasn't","hadn't",
    
    # 存在词/there句型
    "there",
    
    # 疑问词
    "yes","no",
    
    # 数字（口语中经常作为功能性元素）
    "0","1","2","3","4","5","6","7","8","9","10","11","12",
    "one","two","three","four","five","six","seven","eight","nine","ten"
}
# 黑名单：这些实词绝不自动豁免
CONTENT_BLACKLIST = {
    "help","find","show","make","take","give","get","go","come","look","work","call",
    "use","need","try","keep","think","know","feel","tell","ask","play","run","write",
    "people","person","thing","time","way","good","new","old","high","big","small",
    "better","best","always","never","end","begin","start"
}
# 正则：缩写 & 助动
CONTRACTION_RE = re.compile(r"^(?:[a-z]+)('ll|'d|'ve|n't|'re|'m|'s)$", re.I)
AUX_RE = re.compile(r"^(?:be|am|is|are|was|were|been|being|do|does|did|have|has|had)$", re.I)

def is_exempt_candidate(word: str) -> bool:
    w = word.lower().strip()
    if not w or w in CONTENT_BLACKLIST:
        return False
    if w in CLOSED_CLASS:
        return True
    if CONTRACTION_RE.match(w):
        return True
    if AUX_RE.match(w):
        return True
    if len(w) <= 2 and w.isalpha():
        return True
    return False

def load_custom():
    s = set()
    if os.path.exists(FUNCTION_WORDS_FILE):
        with open(FUNCTION_WORDS_FILE, "r", encoding="utf-8") as f:
            for line in f:
                t = line.strip().lower()
                if t:
                    s.add(t)
    return s

def save_custom(words_set):
    with open(FUNCTION_WORDS_FILE, "w", encoding="utf-8") as f:
        for w in sorted(words_set):
            f.write(w + "\n")

def pick_latest_failed():
    files = sorted(glob.glob("logs/failed_batches_*.json"))
    return files[-1] if files else None

def main():
    latest = pick_latest_failed()
    if not latest:
        print("❌ 未找到 logs/failed_batches_*.json，先跑 pipeline 再来哦~")
        return
    with open(latest, "r", encoding="utf-8") as f:
        data = json.load(f)

    failed = []
    # 处理pipeline.py写入的格式：直接是数组
    batches_data = data if isinstance(data, list) else data.get("failed", [])
    for batch in batches_data:
        reason = batch.get("reason","")
        words = batch.get("words", [])
        # 处理所有类型的失败：no-phrases、dialog-mismatch、pos-empty等
        # 功能词在这些场景下都应该被考虑豁免
        failed.extend(words)

    failed = [w.lower() for w in failed]
    before = load_custom()

    candidates = [w for w in failed if is_exempt_candidate(w)]
    new_items = [w for w in candidates if w not in before]

    if not new_items:
        print(f"📄 最新日志: {os.path.basename(latest)}")
        print("没有发现新的可豁免词。")
        return

    updated = before.union(new_items)
    save_custom(updated)
    print(f"📄 最新日志: {os.path.basename(latest)}")
    print(f"候选功能词: {candidates}")
    print(f"✨ 新增 {len(new_items)} 个: {new_items}")
    print(f"📌 当前自定义白名单总数: {len(updated)} （文件 {FUNCTION_WORDS_FILE}）")

if __name__ == "__main__":
    main()
