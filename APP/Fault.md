## 2025-10-05 登录失败后界面卡死（已解决）

- 现象：登录页输入不存在的账号后提示“用户不存在”，随后界面按钮无响应。
- 原因：认证状态一直停留在 `AsyncError`，路由重定向与 UI 监听不到回落状态，导致按钮一直被禁用并出现跳转死循环。
- 处理：
  - 在 `lib/app/router/app_router.dart` 中通过 `ref.watch` 挂载 `authNotifierProvider`，并在重定向中区分加载、错误和已登录三种状态，避免错误态持续触发导航。
  - 重写 `lib/shared/providers/auth_provider.dart`，统一整理登录、注册、更新资料等逻辑，并在登录失败时先发出错误再恢复为未登录的 `AsyncData`，保证界面可以继续交互。
- 验证：`dart format lib/app/router/app_router.dart lib/shared/providers/auth_provider.dart` 通过；实际热重载后再次使用不存在账户登录，提示后按钮可再次点击，导航恢复正常。
