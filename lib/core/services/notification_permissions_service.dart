import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase/firebase_messaging_service.dart';

class NotificationPermissionsService {
  static Future<bool> checkNotificationPermission() async {
    if (Platform.isIOS) {
      // For iOS, check notification settings
      final settings = await FirebaseMessagingService.areNotificationsEnabled();
      return settings;
    } else if (Platform.isAndroid) {
      // For Android, check notification permission
      final status = await Permission.notification.status;
      return status.isGranted;
    }
    return false;
  }

  static Future<bool> requestNotificationPermission(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        // For iOS, request permission through Firebase
        await FirebaseMessagingService.initialize();
        return await FirebaseMessagingService.areNotificationsEnabled();
      } else if (Platform.isAndroid) {
        // For Android, use permission_handler
        final status = await Permission.notification.request();

        if (status.isGranted) {
          // Initialize messaging after permission is granted
          await FirebaseMessagingService.initialize();
          return true;
        } else if (status.isDenied) {
          _showPermissionDeniedDialog(context);
          return false;
        } else if (status.isPermanentlyDenied) {
          _showPermanentlyDeniedDialog(context);
          return false;
        }
      }
      return false;
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('إذن الإشعارات مطلوب'),
        content: const Text(
          'للحصول على إشعارات الطلبات وتحديثات التصويت، يرجى السماح بالإشعارات في إعدادات التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('لاحقاً'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  static void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('إذن الإشعارات مطلوب'),
        content: const Text(
          'تم رفض إذن الإشعارات نهائياً. للحصول على إشعارات الطلبات وتحديثات التصويت، يرجى تفعيل الإشعارات في إعدادات النظام.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  static Future<void> openNotificationSettings() async {
    await FirebaseMessagingService.openNotificationSettings();
  }

  static Future<bool> shouldShowNotificationPermissionRequest() async {
    // Check if we've already asked for permission recently
    // You can implement logic to avoid asking too frequently
    final hasPermission = await checkNotificationPermission();
    return !hasPermission;
  }

  static Future<void> subscribeToNotifications() async {
    final hasPermission = await checkNotificationPermission();
    if (hasPermission) {
      await FirebaseMessagingService.subscribeToOrderNotifications();
      await FirebaseMessagingService.subscribeToTawseyaNotifications();
    }
  }

  static Future<void> unsubscribeFromNotifications() async {
    await FirebaseMessagingService.unsubscribeFromOrderNotifications();
    await FirebaseMessagingService.unsubscribeFromTawseyaNotifications();
  }
}