import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_button.dart';

/// 忘记密码页面
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('忘记密码'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingLarge),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  /// 构建表单视图
  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: DesignTokens.spacingXLarge),
          
          // 图标
          Icon(
            Icons.lock_reset_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 标题和说明
          Text(
            '重置密码',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignTokens.spacingMedium),
          
          Text(
            '请输入您的邮箱地址，我们将发送重置密码的链接到您的邮箱',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: DesignTokens.spacingXXLarge),
          
          // 邮箱输入框
          CustomTextField(
            controller: _emailController,
            labelText: '邮箱',
            hintText: '请输入您的邮箱地址',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: _validateEmail,
            onFieldSubmitted: (_) => _handleForgotPassword(),
          ),
          
          const SizedBox(height: DesignTokens.spacingXLarge),
          
          // 发送按钮
          LoadingButton(
            onPressed: _handleForgotPassword,
            isLoading: _isLoading,
            child: const Text('发送重置邮件'),
          ),
          
          const SizedBox(height: DesignTokens.spacingLarge),
          
          // 返回登录链接
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('想起密码了？'),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('返回登录'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建成功视图
  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: DesignTokens.spacingXLarge),
        
        // 成功图标
        Icon(
          Icons.mark_email_read_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: DesignTokens.spacingLarge),
        
        // 成功标题
        Text(
          '邮件已发送',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: DesignTokens.spacingMedium),
        
        // 成功说明
        Text(
          '我们已经向 ${_emailController.text} 发送了重置密码的邮件，请查收并按照邮件中的说明重置您的密码。',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: DesignTokens.spacingLarge),
        
        // 注意事项
        Card(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: DesignTokens.spacingSmall),
                    Text(
                      '注意事项',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignTokens.spacingSmall),
                Text(
                  '• 请检查您的收件箱和垃圾邮件箱\n'
                  '• 重置链接将在24小时内有效\n'
                  '• 如果未收到邮件，请检查邮箱地址是否正确',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: DesignTokens.spacingXLarge),
        
        // 重新发送按钮
        LoadingButton(
          onPressed: _handleForgotPassword,
          isLoading: _isLoading,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('重新发送'),
        ),
        
        const SizedBox(height: DesignTokens.spacingMedium),
        
        // 返回登录按钮
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('返回登录'),
        ),
      ],
    );
  }

  /// 处理忘记密码
  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = ForgotPasswordRequest(
        email: _emailController.text.trim(),
      );

      await ref.read(authNotifierProvider.notifier).forgotPassword(request);
      
      setState(() => _emailSent = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 验证邮箱
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱地址';
    }
    
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    
    return null;
  }
}