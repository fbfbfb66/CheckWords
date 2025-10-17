import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme/design_tokens.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../l10n/generated/l10n_simple.dart';

/// 用户详情页面
class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late TextEditingController _nameController;
  bool _isEditingName = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _initializeUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 初始化用户数据
  void _initializeUserData() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      _nameController.text = currentUser.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.userProfile),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: currentUser == null
          ? Center(child: Text(S.current.userDataLoadFailed))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignTokens.spacingMedium),
              child: Column(
                children: [
                  // 头像展示和更换
                  _buildAvatarSection(context, currentUser),

                  const SizedBox(height: DesignTokens.spacingXLarge),

                  // 用户名编辑
                  _buildNameSection(context, currentUser),
                ],
              ),
            ),
    );
  }

  /// 构建头像区域
  Widget _buildAvatarSection(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          children: [
            Text(
              '头像',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),

            // 头像展示
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Theme.of(context).colorScheme.primaryContainer,
                image: user.avatarPath != null
                    ? DecorationImage(
                        image: AssetImage(user.avatarPath!) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: user.avatarPath == null
                  ? Center(
                      child: Text(
                        user.name.isNotEmpty ? user.name.substring(0, 1).toUpperCase() : '学',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(height: DesignTokens.spacingMedium),

            // 更换头像按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAvatarOptions(context),
                icon: const Icon(Icons.photo_library),
                label: Text(S.current.changeAvatar),
              ),
            ),

            const SizedBox(height: DesignTokens.spacingSmall),

            // 移除头像按钮
            if (user.avatarPath != null)
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _removeAvatar(),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(S.current.removeAvatar),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 构建用户名区域
  Widget _buildNameSection(BuildContext context, UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '用户名',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMedium),

            if (_isEditingName) ...[
              // 编辑模式
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: S.current.enterUsername,
                  border: const OutlineInputBorder(),
                ),
                maxLength: 20,
                autofocus: true,
              ),
              const SizedBox(height: DesignTokens.spacingMedium),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveUserName(),
                      child: Text(S.current.save),
                    ),
                  ),
                  const SizedBox(width: DesignTokens.spacingMedium),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cancelEditName(),
                      child: Text(S.current.cancel),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // 显示模式
              Row(
                children: [
                  Expanded(
                    child: Text(
                      user.name.isEmpty ? '未设置用户名' : user.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: user.name.isEmpty
                            ? Theme.of(context).colorScheme.outline
                            : null,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _startEditName(user.name),
                    icon: const Icon(Icons.edit),
                    tooltip: '编辑用户名',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 显示头像选择选项
  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.current.fromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(S.current.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 从相册选择图片
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        await _updateAvatar(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.selectImageFailed}: $e')),
        );
      }
    }
  }

  /// 拍照获取图片
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        await _updateAvatar(image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.takePhotoFailed}: $e')),
        );
      }
    }
  }

  /// 更新头像
  Future<void> _updateAvatar(String imagePath) async {
    try {
      await ref.read(userNotifierProvider.notifier).updateProfile(
        UpdateProfileRequest(avatarPath: imagePath),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.avatarUpdateSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.avatarUpdateFailed}: $e')),
        );
      }
    }
  }

  /// 移除头像
  Future<void> _removeAvatar() async {
    try {
      await ref.read(userNotifierProvider.notifier).updateProfile(
        UpdateProfileRequest(avatarPath: null),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.avatarRemoved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.removeAvatarFailed}: $e')),
        );
      }
    }
  }

  /// 开始编辑用户名
  void _startEditName(String currentName) {
    setState(() {
      _isEditingName = true;
      _nameController.text = currentName;
    });
  }

  /// 取消编辑用户名
  void _cancelEditName() {
    setState(() {
      _isEditingName = false;
      _nameController.clear();
      _initializeUserData(); // 重新初始化为原始数据
    });
  }

  /// 保存用户名
  Future<void> _saveUserName() async {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.usernameEmpty)),
        );
      }
      return;
    }

    try {
      await ref.read(userNotifierProvider.notifier).updateProfile(
        UpdateProfileRequest(name: newName),
      );

      setState(() {
        _isEditingName = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.usernameUpdateSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.current.usernameUpdateFailed}: $e')),
        );
      }
    }
  }
}