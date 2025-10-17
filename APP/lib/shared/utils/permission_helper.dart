import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// 权限辅助工具类
class PermissionHelper {
  /// 检查和请求存储权限
  static Future<bool> requestStoragePermissions() async {
    if (!kIsWeb) {
      // Android平台权限处理
      if (defaultTargetPlatform == TargetPlatform.android) {
        debugPrint('📱 检查Android存储权限...');

        // Android 11+ 不再需要存储权限，可以直接使用应用文档目录
        // 但仍请求manageExternalStorage以获得更好的兼容性
        try {
          var manageStatus = await Permission.manageExternalStorage.status;

          if (!manageStatus.isGranted) {
            debugPrint('📱 尝试请求所有文件访问权限...');
            manageStatus = await Permission.manageExternalStorage.request();

            if (manageStatus.isGranted) {
              debugPrint('✅ 获得所有文件访问权限');
            } else if (manageStatus.isPermanentlyDenied) {
              debugPrint('⚠️ 所有文件访问权限被永久拒绝，用户需要手动在设置中开启');
              debugPrint('💡 提示：前往 设置 > 应用 > CheckWords > 权限 > 存储空间 > 允许管理所有文件');
            } else {
              debugPrint('⚠️ 所有文件访问权限被拒绝，但应用仍可正常运行');
            }
          } else {
            debugPrint('✅ 已有所有文件访问权限');
          }
        } catch (e) {
          debugPrint('⚠️ 权限检查出错: $e');
          debugPrint('💡 应用将继续使用基础权限运行');
        }
      }

      // iOS平台权限处理
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        var storageStatus = await Permission.photos.status;

        if (!storageStatus.isGranted) {
          storageStatus = await Permission.photos.request();

          if (!storageStatus.isGranted) {
            debugPrint('❌ iOS照片权限被拒绝');
            return false;
          }
        }
      }
    }

    debugPrint('✅ 存储权限检查完成');
    return true;
  }

  /// 获取应用文档目录权限状态信息
  static Future<Map<String, dynamic>> getPermissionStatus() async {
    final Map<String, dynamic> status = {
      'platform': defaultTargetPlatform.toString(),
      'storage': 'not_checked',
      'manageExternalStorage': 'not_checked',
      'photos': 'not_checked',
    };

    if (!kIsWeb) {
      try {
        status['storage'] = (await Permission.storage.status).toString();

        if (defaultTargetPlatform == TargetPlatform.android) {
          status['manageExternalStorage'] = (await Permission.manageExternalStorage.status).toString();
        }

        if (defaultTargetPlatform == TargetPlatform.iOS) {
          status['photos'] = (await Permission.photos.status).toString();
        }
      } catch (e) {
        status['error'] = e.toString();
      }
    }

    return status;
  }
}