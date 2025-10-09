import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 简化的国际化实现
class S {
  static S? _current;
  static Locale? _locale;
  static Map<String, dynamic>? _translations;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) async {
    _locale = locale;
    final String languageCode = locale.languageCode;
    final String countryCode = locale.countryCode ?? '';
    final String localeKey = '${languageCode}_$countryCode';

    // 加载翻译文件
    final String assetPath = 'lib/l10n/arb/intl_$localeKey.arb';
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      _translations = json.decode(jsonString);
    } catch (e) {
      // 如果找不到对应语言文件，加载中文作为默认
      try {
        final String jsonString = await rootBundle.loadString('lib/l10n/arb/intl_zh_CN.arb');
        _translations = json.decode(jsonString);
      } catch (e) {
        _translations = {};
      }
    }

    final instance = S();
    S._current = instance;
    return instance;
  }

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  static bool isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return true;
      }
    }
    return false;
  }

  String? _translate(String key) {
    if (_translations == null) return key;
    return _translations![key] ?? key;
  }

  // 应用信息
  String get appTitle => _translate('appTitle') ?? 'CheckWords';
  String get appSubtitle => _translate('appSubtitle') ?? '离线优先的词汇学习应用';

  // 认证相关
  String get login => _translate('login') ?? '登录';
  String get register => _translate('register') ?? '注册';
  String get logout => _translate('logout') ?? '退出登录';
  String get forgotPassword => _translate('forgotPassword') ?? '忘记密码';
  String get email => _translate('email') ?? '邮箱';
  String get password => _translate('password') ?? '密码';
  String get name => _translate('name') ?? '姓名';
  String get confirmPassword => _translate('confirmPassword') ?? '确认密码';
  String get currentPassword => _translate('currentPassword') ?? '当前密码';
  String get newPassword => _translate('newPassword') ?? '新密码';
  String get rememberMe => _translate('rememberMe') ?? '记住我';
  String get agreeToTerms => _translate('agreeToTerms') ?? '我已阅读并同意';
  String get userAgreement => _translate('userAgreement') ?? '《用户协议》';
  String get privacyPolicy => _translate('privacyPolicy') ?? '《隐私政策》';

  // 导航
  String get home => _translate('home') ?? '首页';
  String get words => _translate('words') ?? '单词';
  String get profile => _translate('profile') ?? '我的';
  String get settings => _translate('settings') ?? '设置';
  String get wordDetail => _translate('wordDetail') ?? '单词详情';
  String get accountManagement => _translate('accountManagement') ?? '账号管理';

  // 搜索相关
  String get searchWords => _translate('searchWords') ?? '搜索单词...';
  String get searchHistory => _translate('searchHistory') ?? '搜索历史';
  String get popularWords => _translate('popularWords') ?? '热门单词';
  String get recentWords => _translate('recentWords') ?? '最近收录';
  String get favoriteWords => _translate('favoriteWords') ?? '收藏单词';
  String get masteredWords => _translate('masteredWords') ?? '已掌握';
  String get learningWords => _translate('learningWords') ?? '学习中';
  String get viewAll => _translate('viewAll') ?? '查看全部';
  String get more => _translate('more') ?? '更多';

  // 单词详情
  String get pronunciation => _translate('pronunciation') ?? '发音';
  String get phrases => _translate('phrases') ?? '常用短语';
  String get examples => _translate('examples') ?? '例句';
  String get addToFavorite => _translate('addToFavorite') ?? '添加到收藏';
  String get removeFromFavorite => _translate('removeFromFavorite') ?? '从收藏中移除';
  String get playPronunciation => _translate('playPronunciation') ?? '播放发音';

  // 设置相关
  String get themeSettings => _translate('themeSettings') ?? '主题设置';
  String get appearanceDescription => _translate('appearanceDescription') ?? '自定义应用的外观和感受';
  String get themeMode => _translate('themeMode') ?? '主题模式';
  String get followSystem => _translate('followSystem') ?? '跟随系统';
  String get currentLabel => _translate('currentLabel') ?? '当前:';
  String get lightMode => _translate('lightMode') ?? '浅色模式';
  String get darkMode => _translate('darkMode') ?? '深色模式';
  String get font => _translate('font') ?? '字体';
  String get fontInter => _translate('fontInter') ?? 'Inter';
  String get fontSourceHanSans => _translate('fontSourceHanSans') ?? '思源黑体';
  String get useSystemFont => _translate('useSystemFont') ?? '使用系统字体';
  String get appDefault => _translate('appDefault') ?? '应用默认';

  String get learningSettings => _translate('learningSettings') ?? '学习设置';
  String get learningSettingsDescription => _translate('learningSettingsDescription') ?? '配置学习相关的选项';
  String get studyReminderDescription => _translate('studyReminderDescription') ?? '设置定时学习提醒';
  String get autoPlayPronunciationDescription => _translate('autoPlayPronunciationDescription') ?? '查看单词时自动播放发音';
  String get reviewIntervalDescription => _translate('reviewIntervalDescription') ?? '调整记忆曲线的复习间隔';
  String get studyReminder => _translate('studyReminder') ?? '学习提醒';
  String get autoPlayPronunciation => _translate('autoPlayPronunciation') ?? '自动播放发音';
  String get reviewInterval => _translate('reviewInterval') ?? '复习间隔';

  String get dataManagement => _translate('dataManagement') ?? '数据管理';
  String get dataManagementDescription => _translate('dataManagementDescription') ?? '管理您的学习数据';
  String get dataSyncDescription => _translate('dataSyncDescription') ?? '将数据同步到云端';
  String get importWordbookDescription => _translate('importWordbookDescription') ?? '从文件导入单词数据';
  String get exportDataDescription => _translate('exportDataDescription') ?? '导出您的学习数据';
  String get clearDataDescription => _translate('clearDataDescription') ?? '清除所有本地数据';
  String get dataSync => _translate('dataSync') ?? '数据同步';
  String get importWordbook => _translate('importWordbook') ?? '导入单词库';
  String get exportData => _translate('exportData') ?? '导出数据';
  String get clearData => _translate('clearData') ?? '清除数据';

  String get other => _translate('other') ?? '其他';
  String get otherSettingsDescription => _translate('otherSettingsDescription') ?? '更多设置选项';
  String get privacySettingsDescription => _translate('privacySettingsDescription') ?? '管理隐私相关设置';
  String get feedbackDescription => _translate('feedbackDescription') ?? '向我们提供您的建议';
  String get rateAppDescription => _translate('rateAppDescription') ?? '在应用商店给我们评分';
  String get language => _translate('language') ?? '语言';
  String get chinese => _translate('chinese') ?? '简体中文';
  String get english => _translate('english') ?? 'English';
  String get privacySettings => _translate('privacySettings') ?? '隐私设置';
  String get feedback => _translate('feedback') ?? '意见反馈';
  String get rateApp => _translate('rateApp') ?? '评价应用';

  String get version => _translate('version') ?? '版本';
  String get offlineFirst => _translate('offlineFirst') ?? '离线优先的词汇学习应用';

  // 通用
  String get cancel => _translate('cancel') ?? '取消';
  String get confirm => _translate('confirm') ?? '确定';
  String get save => _translate('save') ?? '保存';
  String get delete => _translate('delete') ?? '删除';
  String get clear => _translate('clear') ?? '清除';
  String get retry => _translate('retry') ?? '重试';
  String get loading => _translate('loading') ?? '加载中...';
  String get error => _translate('error') ?? '错误';
  String get success => _translate('success') ?? '成功';

  String get noDataAvailable => _translate('noDataAvailable') ?? '暂无数据';
  String get noSearchHistory => _translate('noSearchHistory') ?? '暂无搜索历史';
  String get noSearchResults => _translate('noSearchResults') ?? '未找到相关单词';
  String get networkError => _translate('networkError') ?? '网络错误';
  String get unknownError => _translate('unknownError') ?? '未知错误';

  String get featureComingSoon => _translate('featureComingSoon') ?? '功能即将推出';
  String get featureNotImplemented => _translate('featureNotImplemented') ?? '功能待实现';

  // 新增的翻译键
  String get registerNowText => _translate('registerNowText') ?? '还没有账户？立即注册';
  String get completed => _translate('completed') ?? '已完成';
  String get remaining => _translate('remaining') ?? '剩余';
  String get clickToViewMeaning => _translate('clickToViewMeaning') ?? '点击下方按钮查看释义';
  String get showMeaning => _translate('showMeaning') ?? '显示释义';
  String get dontKnow => _translate('dontKnow') ?? '不认识';
  String get knowIt => _translate('knowIt') ?? '认识';
  String get learningCompleted => _translate('learningCompleted') ?? '学习完成！';
  String get keepGoing => _translate('keepGoing') ?? '继续保持，加油！';
  String get continueLearning => _translate('continueLearning') ?? '继续学习';
  String get back => _translate('back') ?? '返回';
  String get appearanceCustomization => _translate('appearanceCustomization') ?? '自定义应用的外观和感觉';
  String get searchHint => _translate('searchHint') ?? '搜索...';
  String get noAccountYet => _translate('noAccountYet') ?? '还没有账户？';
  String get registerNow => _translate('registerNow') ?? '立即注册';
  String get dataImportFailed => _translate('dataImportFailed') ?? '词汇数据导入失败';
  String get userNotFound => _translate('userNotFound') ?? '用户不存在';
  String get wrongPasswordError => _translate('wrongPasswordError') ?? '密码错误';
  String get emailAlreadyRegistered => _translate('emailAlreadyRegistered') ?? '邮箱已被注册';
  String get resetPasswordEmailSent => _translate('resetPasswordEmailSent') ?? '重置密码邮件已发送，请查收';
  String get userNotLoggedIn => _translate('userNotLoggedIn') ?? '用户未登录';
  String get newPasswordMismatch => _translate('newPasswordMismatch') ?? '新密码确认不匹配';
  String get currentPasswordError => _translate('currentPasswordError') ?? '当前密码错误';
  String get checkFavoriteStatusFailed => _translate('checkFavoriteStatusFailed') ?? '检查收藏状态失败';
  String get getFavoriteWordsFailed => _translate('getFavoriteWordsFailed') ?? '获取收藏单词失败';
  String get getFavoriteCountFailed => _translate('getFavoriteCountFailed') ?? '获取收藏数量失败';
  String get batchOperationFailed => _translate('batchOperationFailed') ?? '批量操作失败';
  String get clearFavoritesFailed => _translate('clearFavoritesFailed') ?? '清空失败';
  String get loadLearningWordsFailed => _translate('loadLearningWordsFailed') ?? '加载学习单词失败';
  String get resetFavoriteWordsStatusFailed => _translate('resetFavoriteWordsStatusFailed') ?? '重置收藏单词状态失败';
  String get updateLearningStatusFailed => _translate('updateLearningStatusFailed') ?? '更新学习状态失败';
  String get getWordDetailFailed => _translate('getWordDetailFailed') ?? '获取单词详情失败';
  String get getWordByNameFailed => _translate('getWordByNameFailed') ?? '根据名称获取单词失败';
  String get searchWordsFailed => _translate('searchWordsFailed') ?? '搜索单词失败';
  String get fuzzySearchFailed => _translate('fuzzySearchFailed') ?? '模糊搜索失败';
  String get getPopularWordsFailed => _translate('getPopularWordsFailed') ?? '获取热门单词失败';
  String get getWordsByLevelFailed => _translate('getWordsByLevelFailed') ?? '根据等级获取单词失败';
  String get databaseNoData => _translate('databaseNoData') ?? '数据库中没有单词数据，请先导入数据';
  String get rebuildFTS5IndexFailed => _translate('rebuildFTS5IndexFailed') ?? '重建FTS5索引失败';
  String get diagnosticReport => _translate('diagnosticReport') ?? '诊断报告';
  String get generatedAt => _translate('generatedAt') ?? '生成时间';
  String get dataImportStatus => _translate('dataImportStatus') ?? '数据导入状态';
  String get databaseStats => _translate('databaseStats') ?? '数据库统计';
  String get systemInfo => _translate('systemInfo') ?? '系统信息';
  String get errorInfo => _translate('errorInfo') ?? '错误信息';
  String get vacuumSuccess => _translate('vacuumSuccess') ?? '成功';
  String get analyzeSuccess => _translate('analyzeSuccess') ?? '成功';
  String get ftsRebuildSuccess => _translate('ftsRebuildSuccess') ?? '成功';

  // 补充缺失的翻译键
  String get collectedWords => _translate('collectedWords') ?? '收录单词';
  String get noCollectedData => _translate('noCollectedData') ?? '暂无收录数据';
  String get allFavoriteWordsCompleted => _translate('allFavoriteWordsCompleted') ?? '收藏的单词都已学完';
  String get noWordsToLearn => _translate('noWordsToLearn') ?? '暂无待学习单词';
  String get noLearningWords => _translate('noLearningWords') ?? '暂无学习单词';
  String get resetLearningProgressDescription => _translate('resetLearningProgressDescription') ?? '点击下方按钮可以重置学习进度，再次开始学习这些收藏的单词。';
  String get allWordsLearnedDescription => _translate('allWordsLearnedDescription') ?? '收藏的单词已全部学习完成，可前往收录页添加新的学习目标。';
  String get noFavoriteWordsDescription => _translate('noFavoriteWordsDescription') ?? '请先在单词页面收藏一些单词再来学习。';
  String get restartLearning => _translate('restartLearning') ?? '重新开始学习';
  String get confirmExit => _translate('confirmExit') ?? '确认退出';
  String get confirmExitMessage => _translate('confirmExitMessage') ?? '确定要退出学习吗？当前进度将会保存。';
  String get pleaseLoginFirst => _translate('pleaseLoginFirst') ?? '请先登录';
  String get loginToStartLearning => _translate('loginToStartLearning') ?? '登录后即可开始学习单词。';
  String get favoriteWordsCompleted => _translate('favoriteWordsCompleted') ?? '收藏单词';
  String get clickToShowMeaning => _translate('clickToShowMeaning') ?? '点击下方按钮查看释义';

  // 补充缺失的翻译键 - Profile页面
  String get pleaseLogin => _translate('pleaseLogin') ?? '请登录';
  String get loginToUseFullFeatures => _translate('loginToUseFullFeatures') ?? '登录后可以收藏单词、查看学习记录等功能';
  String get recentWordsTitle => _translate('recentWordsTitle') ?? '最近收录';
  String get loadFailed => _translate('loadFailed') ?? '加载失败';
  String get learningRecordTitle => _translate('learningRecordTitle') ?? '学习记录';
  String get learningRecordSubtitle => _translate('learningRecordSubtitle') ?? '查看您的学习历史和进度';
  String get learningStatsTitle => _translate('learningStatsTitle') ?? '学习统计';
  String get learningStatsSubtitle => _translate('learningStatsSubtitle') ?? '查看详细的学习数据分析';
  String get dataBackupTitle => _translate('dataBackupTitle') ?? '数据备份';
  String get dataBackupSubtitle => _translate('dataBackupSubtitle') ?? '备份您的学习数据到云端';
  String get helpAndFeedbackTitle => _translate('helpAndFeedbackTitle') ?? '帮助与反馈';
  String get helpAndFeedbackSubtitle => _translate('helpAndFeedbackSubtitle') ?? '获取帮助或提交反馈';
  String get aboutTitle => _translate('aboutTitle') ?? '关于';
  String get aboutSubtitle => _translate('aboutSubtitle') ?? '应用版本和相关信息';

  // 账号管理页面翻译键
  String get userNotLoggedInText => _translate('userNotLoggedInText') ?? '用户未登录';
  String get changeAvatar => _translate('changeAvatar') ?? '点击更换头像';
  String get basicInfoTitle => _translate('basicInfoTitle') ?? '基本信息';
  String get emailLabel => _translate('emailLabel') ?? '邮箱';
  String get nameLabel => _translate('nameLabel') ?? '姓名';
  String get saveName => _translate('saveName') ?? '保存姓名';
  String get changePasswordTitle => _translate('changePasswordTitle') ?? '修改密码';
  String get currentPasswordLabel => _translate('currentPasswordLabel') ?? '当前密码';
  String get newPasswordLabel => _translate('newPasswordLabel') ?? '新密码';
  String get confirmNewPasswordLabel => _translate('confirmNewPasswordLabel') ?? '确认新密码';
  String get savePassword => _translate('savePassword') ?? '保存密码';
  String get logoutButton => _translate('logoutButton') ?? '退出登录';
  String get selectAvatarTitle => _translate('selectAvatarTitle') ?? '选择头像';
  String get fromGalleryTitle => _translate('fromGalleryTitle') ?? '从相册选择';
  String get takePhotoTitle => _translate('takePhotoTitle') ?? '拍照';
  String get avatarUpdateSuccess => _translate('avatarUpdateSuccess') ?? '头像更新成功';
  String get nameUpdateSuccess => _translate('nameUpdateSuccess') ?? '姓名更新成功';
  String get passwordChangeSuccess => _translate('passwordChangeSuccess') ?? '密码修改成功';
  String get confirmLogoutTitle => _translate('confirmLogoutTitle') ?? '退出登录';
  String get confirmLogoutMessage => _translate('confirmLogoutMessage') ?? '确定要退出当前账户吗？';
  String get confirmLogoutButton => _translate('confirmLogoutButton') ?? '确定';
  String get pleaseEnterName => _translate('pleaseEnterName') ?? '请输入姓名';
  String get nameTooShortValidation => _translate('nameTooShortValidation') ?? '姓名长度不能少于2位';
  String get nameTooLongValidation => _translate('nameTooLongValidation') ?? '姓名长度不能超过20位';
  String get pleaseEnterCurrentPassword => _translate('pleaseEnterCurrentPassword') ?? '请输入当前密码';
  String get pleaseEnterNewPassword => _translate('pleaseEnterNewPassword') ?? '请输入新密码';
  String get passwordTooShortValidation => _translate('passwordTooShortValidation') ?? '密码长度不能少于6位';
  String get newPasswordSameAsCurrent => _translate('newPasswordSameAsCurrent') ?? '新密码不能与当前密码相同';
  String get passwordValidationRules => _translate('passwordValidationRules') ?? '密码必须包含字母和数字';
  String get pleaseConfirmNewPassword => _translate('pleaseConfirmNewPassword') ?? '请确认新密码';
  String get passwordMismatchValidation => _translate('passwordMismatchValidation') ?? '两次输入的密码不一致';

  // 格式化文本方法
  String completedCount(int count) => _translate('completedCount')?.replaceAll('{count}', count.toString()) ?? '已完成: $count';
  String remainingCount(int count) => _translate('remainingCount')?.replaceAll('{count}', count.toString()) ?? '剩余: $count';
  String collectedCountWords(int count) => _translate('collectedCountWords')?.replaceAll('{count}', count.toString()) ?? '已收录 $count 个单词';

  // 错误消息格式化方法
  String avatarUpdateFailed(String error) => _translate('avatarUpdateFailed')?.replaceAll('{error}', error) ?? '头像更新失败：$error';
  String nameUpdateFailed(String error) => _translate('nameUpdateFailed')?.replaceAll('{error}', error) ?? '姓名更新失败：$error';
  String passwordChangeFailed(String error) => _translate('passwordChangeFailed')?.replaceAll('{error}', error) ?? '密码修改失败：$error';

  // Words页面翻译键
  String get searchWordsHint => _translate('searchWordsHint') ?? '搜索单词...';
  String get searchHistoryTitle => _translate('searchHistoryTitle') ?? '搜索历史';
  String get clearAll => _translate('clearAll') ?? '清除全部';
  String get noSearchHistoryText => _translate('noSearchHistoryText') ?? '暂无搜索历史';
  String get searchHistoryDescription => _translate('searchHistoryDescription') ?? '搜索单词后，历史记录会出现在这里';
  String get moreText => _translate('moreText') ?? '更多';
  String get loadingText => _translate('loadingText') ?? '加载中…';
  String get noMeaningAvailable => _translate('noMeaningAvailable') ?? '暂无释义';
  String get noWordsFound => _translate('noWordsFound') ?? '查询不到相关单词';
  String get pleaseTry => _translate('pleaseTry') ?? '请尝试：';
  String get checkSpellingHint => _translate('checkSpellingHint') ?? '检查拼写是否正确';
  String get trySynonymsHint => _translate('trySynonymsHint') ?? '尝试使用同义词';
  String get tryShorterKeywordsHint => _translate('tryShorterKeywordsHint') ?? '尝试更简短的关键词';
  String get loadFailedText => _translate('loadFailedText') ?? '加载失败: ';
  String get retryButton => _translate('retryButton') ?? '重试';
  String get clearSearchHistoryTitle => _translate('clearSearchHistoryTitle') ?? '清除搜索历史';
  String get clearSearchHistoryMessage => _translate('clearSearchHistoryMessage') ?? '确定要清除所有搜索历史吗？';
  String get searchHistoryCleared => _translate('searchHistoryCleared') ?? '搜索历史已清空';
  String get quickDebug => _translate('quickDebug') ?? '快速调试';
  String get avatarLabel => _translate('avatarLabel') ?? '头像';

  // 登录页面翻译键
  String get loginToYourAccount => _translate('loginToYourAccount') ?? '登录您的账户';
  String get emailAddressHint => _translate('emailAddressHint') ?? '请输入邮箱地址';
  String get passwordHint => _translate('passwordHint') ?? '请输入密码';
  String get rememberMeOption => _translate('rememberMeOption') ?? '记住我';
  String get forgotPasswordLink => _translate('forgotPasswordLink') ?? '忘记密码？';
  String get alreadyHaveAccount => _translate('alreadyHaveAccount') ?? '还没有账户？';
  String get registerNowLink => _translate('registerNowLink') ?? '立即注册';
  String get pleaseEnterEmailAddress => _translate('pleaseEnterEmailAddress') ?? '请输入邮箱地址';
  String get pleaseEnterValidEmail => _translate('pleaseEnterValidEmail') ?? '请输入有效的邮箱地址';
  String get pleaseEnterPassword => _translate('pleaseEnterPassword') ?? '请输入密码';
  String get passwordMinLengthValidation => _translate('passwordMinLengthValidation') ?? '密码长度不能少于6位';
  String get backTooltip => _translate('backTooltip') ?? '返回';

  // 注册页面翻译键
  String get createNewAccount => _translate('createNewAccount') ?? '创建新账户';
  String get joinCheckWords => _translate('joinCheckWords') ?? '加入CheckWords，开始您的学习之旅';
  String get pleaseEnterYourName => _translate('pleaseEnterYourName') ?? '请输入您的姓名';
  String get passwordWithMinLengthHint => _translate('passwordWithMinLengthHint') ?? '请输入密码（至少6位）';
  String get confirmPasswordHint => _translate('confirmPasswordHint') ?? '请再次输入密码';
  String get iHaveReadAndAgree => _translate('iHaveReadAndAgree') ?? '我已阅读并同意';
  String get and => _translate('and') ?? '和';
  String get haveAccount => _translate('haveAccount') ?? '已有账户？';
  String get loginNowLink => _translate('loginNowLink') ?? '立即登录';
  String get pleaseAgreeToTerms => _translate('pleaseAgreeToTerms') ?? '请先同意用户协议和隐私政策';
  String get passwordMustContainLettersAndNumbers => _translate('passwordMustContainLettersAndNumbers') ?? '密码必须包含字母和数字';
  String get pleaseConfirmPassword => _translate('pleaseConfirmPassword') ?? '请确认密码';
  String get passwordsDoNotMatch => _translate('passwordsDoNotMatch') ?? '两次输入的密码不一致';

  // 账户管理页面新增翻译键
  String get tapToChangeAvatar => _translate('tapToChangeAvatar') ?? '点击更换头像';
  String get basicInfo => _translate('basicInfo') ?? '基本信息';
  String get changePassword => _translate('changePassword') ?? '修改密码';
  String get confirmNewPassword => _translate('confirmNewPassword') ?? '确认新密码';
  String get selectAvatar => _translate('selectAvatar') ?? '选择头像';
  String get selectFromGallery => _translate('selectFromGallery') ?? '从相册选择';
  String get takePhoto => _translate('takePhoto') ?? '拍照';
  String get logoutConfirmation => _translate('logoutConfirmation') ?? '确定要退出当前账户吗？';

  // 收录单词页面相关翻译
  String get collected => _translate('collected') ?? '收录';
  String get mastered => _translate('mastered') ?? '已掌握';
  String get learning => _translate('learning') ?? '学习中';
  String get masteredWithCount => _translate('masteredWithCount') ?? '已掌握 (0)';
  String get learningWithCount => _translate('learningWithCount') ?? '学习中 (0)';
  String get searchCollectedWords => _translate('searchCollectedWords') ?? '搜索收录的单词...';
  String get searchFailed => _translate('searchFailed') ?? '搜索失败';
  String get noCollectedWords => _translate('noCollectedWords') ?? '还没有收录的单词';
  String get noMasteredWords => _translate('noMasteredWords') ?? '还没有已掌握的单词';
  String get noCollectedWordsSubtitle => _translate('noCollectedWordsSubtitle') ?? '在搜索页面找到喜欢的单词，点击收录按钮将它们添加到这里';
  String get noMasteredWordsSubtitle => _translate('noMasteredWordsSubtitle') ?? '学习过程中掌握的单词会出现在这里';
  String get noLearningWordsSubtitle => _translate('noLearningWordsSubtitle') ?? '正在学习的单词会出现在这里';
  String get goToLearning => _translate('goToLearning') ?? '去学习';
  String get goToSearchWords => _translate('goToSearchWords') ?? '去搜索单词';
  String get clearSearch => _translate('clearSearch') ?? '清除搜索';
  String get loginToViewCollectedWords => _translate('loginToViewCollectedWords') ?? '登录后可以查看您收录的单词';
  String get pronunciationFeatureNotImplemented => _translate('pronunciationFeatureNotImplemented') ?? '发音功能待实现';
  String get removeFromCollection => _translate('removeFromCollection') ?? '取消收录';
  String get addToCollection => _translate('addToCollection') ?? '收录';
  String get markAsMastered => _translate('markAsMastered') ?? '标记为已掌握';
  String get markAsLearning => _translate('markAsLearning') ?? '标记为学习中';
  String get removeWord => _translate('removeWord') ?? '移除收录';
  String get gotIt => _translate('gotIt') ?? '知道了';
  String get confirmRemoveWord => _translate('confirmRemoveWord') ?? '移除收录';
  String get remove => _translate('remove') ?? '移除';
  String get loginNow => _translate('loginNow') ?? '立即登录';

  // 忘记密码页面相关翻译
  String get resetPassword => _translate('resetPassword') ?? '重置密码';
  String get resetPasswordDescription => _translate('resetPasswordDescription') ?? '请输入您的邮箱地址，我们将发送重置密码的链接到您的邮箱';
  String get sendResetEmail => _translate('sendResetEmail') ?? '发送重置邮件';
  String get rememberPassword => _translate('rememberPassword') ?? '想起密码了？';
  String get backToLogin => _translate('backToLogin') ?? '返回登录';
  String get emailSent => _translate('emailSent') ?? '邮件已发送';
  String get importantNotes => _translate('importantNotes') ?? '注意事项';
  String get emailSentInstructions => _translate('emailSentInstructions') ?? '• 请检查您的收件箱和垃圾邮件箱\n• 重置链接将在24小时内有效\n• 如果未收到邮件，请检查邮箱地址是否正确';
  String get resendEmail => _translate('resendEmail') ?? '重新发送';

  // 格式化方法
  String searchResultsFor(String query) => _translate('searchResultsFor')?.replaceAll('{query}', query) ?? '搜索 "$query" 的结果';
  String noWordsFoundForQuery(String query) => _translate('noWordsFoundForQuery')?.replaceAll('{query}', query) ?? '没有找到与 "$query" 相关的单词';
  String clearFailed(String error) => _translate('clearFailed')?.replaceAll('{error}', error) ?? '清除失败：$error';

  // 收录单词页面的格式化方法
  String noWordsFoundInCategory(String category, String query) => _translate('noWordsFoundInCategory')?.replaceAll('{category}', category).replaceAll('{query}', query) ?? '在$category中未找到包含"$query"的单词';
  String operationFailed(String error) => _translate('operationFailed')?.replaceAll('{error}', error) ?? '操作失败：$error';
  String featureWillBeImplemented(String feature) => _translate('featureWillBeImplemented')?.replaceAll('{feature}', feature) ?? '$feature功能将在后续版本中实现';
  String wordAddedToCollection(String word) => _translate('wordAddedToCollection')?.replaceAll('{word}', word) ?? '已收录单词："$word"';
  String wordRemovedFromCollection(String word) => _translate('wordRemovedFromCollection')?.replaceAll('{word}', word) ?? '已取消收录："$word"';
  String confirmRemoveWordMessage(String word) => _translate('confirmRemoveWordMessage')?.replaceAll('{word}', word) ?? '确定要移除单词 "$word" 吗？';

  // 忘记密码页面的格式化方法
  String emailSentDescription(String email) => _translate('emailSentDescription')?.replaceAll('{email}', email) ?? '我们已经向 $email 发送了重置密码的邮件，请查收并按照邮件中的说明重置您的密码。';
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => S.isSupported(locale);

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<S> old) {
    // 始终重新加载以确保语言切换立即生效
    return true;
  }
}