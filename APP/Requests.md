我的app会在Android Studio里进行测试
0）鉴权与状态（全局约定）

全局 AuthState（riverpod）：{ isAuthed, user }

未登录时：

“我的”显示请登录卡片（按钮跳转登录页）；

收藏、账号管理等入口点击 → 触发登录页。

登录成功：返回首页/来源页，顶部吐司“已登录”；本地持久化 user 与 token（先内存占位，后接 API）

A）登录页（Login）

布局

AppBar：返回

表单：

账号（email 或手机号二选一，你先用 email 简化）

密码（可见/不可见切换）

提交按钮

辅助：

「没有账号？去注册」

「忘记密码？」

校验

email：格式校验

密码：长度 ≥ 6

交互/状态

点击提交：loading → 成功进入上一页/首页；失败显示错误文案

错误样式：字段下方红色提示 + 顶部/底部轻提示

实现要点（Flutter 提示）

TextFormField + Form + GlobalKey

ObscureText 切换

ElevatedButton disabled/加载态

provider：authProvider.signIn(email, pwd)（先模拟）

B）注册页（Sign Up）

布局

email、密码、重复密码、昵称（可选）

勾选同意条款（占位）

注册按钮

校验

email 格式

密码：≥ 6 且包含字母/数字任意两类（简单规则即可）

两次密码一致

交互

成功后自动登录并跳首页；或跳“完善资料”（可后做）

C）忘记密码页（Forgot Password）

布局

email

发送重置链接按钮（或验证码流程，占位）

交互

成功：提示“邮件已发送，请查收”并提供回登录入口

D）我的页（Profile）

头像 + name

收录单词

按钮：账号管理

设置入口仍在首页右上角

E）账号管理页（Account Management）

布局

头像（可从相册选择）

基本信息：name、email（email 只读或可改，看你后端设计；先只读）

修改名字：TextField + 保存

修改密码：

当前密码

新密码

确认新密码

保存按钮

退出登录按钮(未登录状态的“我的”显示请登录卡片（按钮跳转登录页）)

校验

名称：1–20 字符

密码：同注册规则，新旧不能相同

交互

头像：点按 → 打开相册 → 选择后预览 → 保存

修改成功均给出轻提示

退出：清空 AuthState 与本地缓存 → 回到“我的”未登录态

实现要点（Flutter 提示）

头像：image_picker（相册），本地先存 File 路径

表单分区：分组卡片 + 分割线，按钮固定在底部安全区域

provider：authProvider.updateProfile(...) / updatePassword(...)（先模拟）

1. 首页（Words）

顶部右上设置按钮 → 进入设置页

搜索框 + 历史查词（可滚动）

历史项点击 → 单词详情页

底部导航保持不变

2. 设置页（Settings）

主题：Warm(默认)/Dark

字体：预设切换(你找2个好看的，有一个默认跟随系统)

底部：版本号（如 v0.1.0）

3. 我的页（Profile）

头像

name

账号管理入口

收录列表（收藏的词）

4. 单词详情（Detail）

第一栏：word、parts_of_speech、pos_meanings[0].cn、爱心收藏

收藏需要登录：未登录点击 → 跳登录

第二栏：音标/音频（音频为空先占位；将来接 TTS 开关）

第三栏（可折叠）：phrases[].phrase + dialog(A/B) 聊天气泡

若 phrases 为空，则第三栏省略

第四栏：sentences 中英文对照

若第三栏省略，则例句上移为第三栏

这里是资源里Resource的json样式:
{ "word": "absolutely", "parts_of_speech": [ "adv" ], "pos_meanings": [ { "pos": "adv", "cn": "绝对地；完全地" } ], "phrases": [ { "phrase": "absolutely not", "dialog": { "A": "Are you coming to the party?", "B": "Absolutely not, I have other plans." } } ], "sentences": [ { "en": "Your conduct is absolutely shameful.", "zh": "你的行为是绝对可耻的。" }, { "en": "It is absolutely impossible to do so.", "zh": "绝对不可能这样做的。" } ], "pronunciation": { "US": { "ipa": "/ˌæbsʌlˈuːtliː/", "audio": null } } }

但这只是格式，你不需要从json获取单词，你需要从SQlite里获取。资源.db在Resource文件里

数据模型（新增 user 占位）
{
  "user": {
    "id": "uuid",
    "name": "Goings",
    "email": "xx@example.com",
    "avatar": "file:///path/to/avatar.png"  // 本地占位
  },
  "auth": {
    "isAuthed": true
  }
}