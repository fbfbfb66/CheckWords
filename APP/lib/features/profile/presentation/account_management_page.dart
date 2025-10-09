import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 账号管理页面
class AccountManagementPage extends ConsumerStatefulWidget {
  const AccountManagementPage({super.key});

  @override
  ConsumerState<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends ConsumerState<AccountManagementPage> {
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isUpdatingName = false;
  bool _isChangingPassword = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 初始化用户数据
  void _initializeUserData() {
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _nameController.text = user.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(S.current.accountManagement)),
        body: Center(child: Text(S.current.userNotLoggedInText)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.accountManagement),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignTokens.spacingMedium),
          child: Column(
            children: [
              // 头像区域
              _buildAvatarSection(currentUser),
              
              const SizedBox(height: DesignTokens.spacingXLarge),
              
              // 基本信息区域
              _buildBasicInfoSection(currentUser),
              
              const SizedBox(height: DesignTokens.spacingLarge),
              
              // 修改密码区域
              _buildPasswordSection(),
              
              const SizedBox(height: DesignTokens.spacingXLarge),
              
              // 退出登录按钮
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建头像区域
  Widget _buildAvatarSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          children: [
            Text(
              S.current.avatarLabel,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingLarge),
            
            // 头像显示
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage: _getAvatarImage(user),
                    child: _getAvatarChild(user),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingMedium),
            
            Text(
              S.current.tapToChangeAvatar,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取头像图片
  ImageProvider? _getAvatarImage(UserModel user) {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    if (user.avatarPath != null && user.avatarPath!.isNotEmpty) {
      return NetworkImage(user.avatarPath!); // 或者其他适合的ImageProvider
    }
    return null;
  }

  /// 获取头像子组件
  Widget? _getAvatarChild(UserModel user) {
    if (_selectedImage != null || (user.avatarPath != null && user.avatarPath!.isNotEmpty)) {
      return null;
    }
    
    return Text(
      user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : 'U',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 构建基本信息区域
  Widget _buildBasicInfoSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.basicInfo,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: DesignTokens.spacingLarge),
            
            // 邮箱（只读）
            CustomTextField(
              labelText: S.current.email,
              controller: TextEditingController(text: user.email),
              enabled: false,
              prefixIcon: Icons.email_outlined,
            ),
            
            const SizedBox(height: DesignTokens.spacingLarge),
            
            // 姓名修改
            Form(
              key: _nameFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: S.current.name,
                    prefixIcon: Icons.person_outlined,
                    validator: _validateName,
                  ),
                  
                  const SizedBox(height: DesignTokens.spacingMedium),
                  
                  LoadingButton(
                    onPressed: _updateName,
                    isLoading: _isUpdatingName,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(S.current.saveName),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建密码区域
  Widget _buildPasswordSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Form(
          key: _passwordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.changePassword,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: DesignTokens.spacingLarge),
              
              // 当前密码
              CustomTextField(
                controller: _currentPasswordController,
                labelText: S.current.currentPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: _obscureCurrentPassword,
                validator: _validateCurrentPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                ),
              ),
              
              const SizedBox(height: DesignTokens.spacingLarge),
              
              // 新密码
              CustomTextField(
                controller: _newPasswordController,
                labelText: S.current.newPassword,
                prefixIcon: Icons.lock_reset_outlined,
                obscureText: _obscureNewPassword,
                validator: _validateNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                ),
              ),
              
              const SizedBox(height: DesignTokens.spacingLarge),
              
              // 确认新密码
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: S.current.confirmNewPassword,
                prefixIcon: Icons.lock_outlined,
                obscureText: _obscureConfirmPassword,
                validator: _validateConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  ),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              
              const SizedBox(height: DesignTokens.spacingLarge),
              
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  onPressed: _changePassword,
                  isLoading: _isChangingPassword,
                  child: Text(S.current.savePassword),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建退出登录按钮
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _showLogoutDialog,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: Text(S.current.logout),
      ),
    );
  }

  /// 选择头像
  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.selectAvatar),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.current.selectFromGallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.current.takePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        await _updateAvatar(image.path);
      }
    }
  }

  /// 更新头像
  Future<void> _updateAvatar(String imagePath) async {
    try {
      final request = UpdateProfileRequest(avatarPath: imagePath);
      await ref.read(authNotifierProvider.notifier).updateProfile(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.avatarUpdateSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.current.avatarUpdateFailed}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// 更新姓名
  Future<void> _updateName() async {
    if (!_nameFormKey.currentState!.validate()) return;

    setState(() => _isUpdatingName = true);

    try {
      final request = UpdateProfileRequest(name: _nameController.text.trim());
      await ref.read(authNotifierProvider.notifier).updateProfile(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.nameUpdateSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.current.nameUpdateFailed}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isUpdatingName = false);
    }
  }

  /// 修改密码
  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() => _isChangingPassword = true);

    try {
      final request = ChangePasswordRequest(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      
      await ref.read(authNotifierProvider.notifier).changePassword(request);
      
      // 清空密码输入框
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.passwordChangeSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${S.current.passwordChangeFailed}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isChangingPassword = false);
    }
  }

  /// 显示退出登录对话框
  void _showLogoutDialog() {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.current.logout),
        content: Text(S.current.logoutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.current.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.current.confirm),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(authNotifierProvider.notifier).signOut();
        Navigator.of(context).pop(); // 返回上一页
      }
    });
  }

  /// 验证姓名
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return S.current.pleaseEnterName;
    }
    if (value.trim().length < 2) {
      return '姓名长度不能少于2位';
    }
    if (value.trim().length > 20) {
      return '姓名长度不能超过20位';
    }
    return null;
  }

  /// 验证当前密码
  String? _validateCurrentPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.pleaseEnterCurrentPassword;
    }
    return null;
  }

  /// 验证新密码
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.pleaseEnterNewPassword;
    }
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    if (value == _currentPasswordController.text) {
      return '新密码不能与当前密码相同';
    }
    
    // 简单的密码强度检查
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
      return S.current.pleaseConfirmNewPassword;
    }
    if (value != _newPasswordController.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }
}