import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/providers/locale_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 注册页面
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // 监听 locale 变化以确保页面在语言切换时重建
    ref.watch(localeNotifierProvider);

    // 监听认证状态变化
    ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (previous, next) {
      next.whenOrNull(
        data: (state) {
          if (state.isAuthenticated && state.isValid) {
            context.go(RoutePaths.home);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.register),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 标题
                Icon(
                  Icons.person_add_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: DesignTokens.spacingMedium),
                
                Text(
                  S.current.createNewAccount,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacingSmall),
                
                Text(
                  S.current.joinCheckWords,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: DesignTokens.spacingXXLarge),
                
                // 姓名输入框
                CustomTextField(
                  controller: _nameController,
                  labelText: S.current.name,
                  hintText: S.current.pleaseEnterYourName,
                  prefixIcon: Icons.person_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 邮箱输入框
                CustomTextField(
                  controller: _emailController,
                  labelText: S.current.email,
                  hintText: S.current.emailAddressHint,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: _validateEmail,
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 密码输入框
                CustomTextField(
                  controller: _passwordController,
                  labelText: S.current.password,
                  hintText: S.current.passwordWithMinLengthHint,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 确认密码输入框
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: S.current.confirmPassword,
                  hintText: S.current.confirmPasswordHint,
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  onFieldSubmitted: (_) => _handleRegister(),
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 同意条款
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(S.current.iHaveReadAndAgree),
                          TextButton(
                            onPressed: () {
                              // TODO: 显示用户协议
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(S.current.userAgreement),
                          ),
                          Text(S.current.and),
                          TextButton(
                            onPressed: () {
                              // TODO: 显示隐私政策
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(S.current.privacyPolicy),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 注册按钮
                LoadingButton(
                  onPressed: _agreeToTerms ? _handleRegister : null,
                  isLoading: authState.isLoading,
                  child: Text(S.current.register),
                ),
                
                const SizedBox(height: DesignTokens.spacingLarge),
                
                // 登录链接
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.current.haveAccount),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(S.current.loginNowLink),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 处理注册
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.pleaseAgreeToTerms)),
      );
      return;
    }

    final request = RegisterRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      agreeToTerms: _agreeToTerms,
    );

    await ref.read(authNotifierProvider.notifier).signUp(request);
  }

  /// 验证姓名
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.pleaseEnterYourName;
    }
    
    if (value.trim().length < 2) {
      return '姓名长度不能少于2位';
    }
    
    if (value.trim().length > 20) {
      return '姓名长度不能超过20位';
    }
    
    return null;
  }

  /// 验证邮箱
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.pleaseEnterEmailAddress;
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return S.current.pleaseEnterValidEmail;
    }
    
    return null;
  }

  /// 验证密码
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.pleaseEnterPassword;
    }
    
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    
    // 简单的密码强度检查：包含字母和数字
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    
    if (!hasLetter || !hasNumber) {
      return '密码必须包含字母和数字';
    }
    
    return null;
  }

  /// 验证确认密码
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.pleaseConfirmPassword;
    }
    
    if (value != _passwordController.text) {
      return '两次输入的密码不一致';
    }
    
    return null;
  }
}