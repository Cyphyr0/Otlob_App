import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_permissions_service.dart';
import '../../../../core/utils/localization_helper.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderNotifications = true;
  bool _tawseyaNotifications = true;
  bool _promotionalNotifications = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    setState(() => _loading = true);

    try {
      final enabled = await NotificationPermissionsService.checkNotificationPermission();
      setState(() {
        _notificationsEnabled = enabled;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showErrorSnackBar('خطأ في تحميل إعدادات الإشعارات');
    }
  }

  Future<void> _toggleNotifications() async {
    setState(() => _loading = true);

    try {
      if (_notificationsEnabled) {
        // Disable notifications
        await NotificationPermissionsService.unsubscribeFromNotifications();
        setState(() {
          _notificationsEnabled = false;
          _orderNotifications = false;
          _tawseyaNotifications = false;
          _promotionalNotifications = false;
          _loading = false;
        });
      } else {
        // Request permission and enable notifications
        final granted = await NotificationPermissionsService.requestNotificationPermission(context);
        if (granted) {
          await NotificationPermissionsService.subscribeToNotifications();
          setState(() {
            _notificationsEnabled = true;
            _orderNotifications = true;
            _tawseyaNotifications = true;
            _loading = false;
          });
        } else {
          setState(() => _loading = false);
        }
      }
    } catch (e) {
      setState(() => _loading = false);
      _showErrorSnackBar('خطأ في تحديث إعدادات الإشعارات');
    }
  }

  Future<void> _updateOrderNotifications(bool value) async {
    setState(() => _orderNotifications = value);

    try {
      if (value) {
        // Enable order notifications - need to check if main notifications are enabled first
        if (!_notificationsEnabled) {
          final granted = await NotificationPermissionsService.requestNotificationPermission(context);
          if (granted) {
            await NotificationPermissionsService.subscribeToNotifications();
            setState(() => _notificationsEnabled = true);
          } else {
            setState(() => _orderNotifications = false);
            return;
          }
        }
      } else {
        // Disable order notifications only
        // Note: In a real implementation, you might want more granular control
      }
    } catch (e) {
      setState(() => _orderNotifications = !_orderNotifications);
      _showErrorSnackBar('خطأ في تحديث إشعارات الطلبات');
    }
  }

  Future<void> _updateTawseyaNotifications(bool value) async {
    setState(() => _tawseyaNotifications = value);

    try {
      if (value) {
        // Enable Tawseya notifications - need to check if main notifications are enabled first
        if (!_notificationsEnabled) {
          final granted = await NotificationPermissionsService.requestNotificationPermission(context);
          if (granted) {
            await NotificationPermissionsService.subscribeToNotifications();
            setState(() => _notificationsEnabled = true);
          } else {
            setState(() => _tawseyaNotifications = false);
            return;
          }
        }
      } else {
        // Disable Tawseya notifications only
        // Note: In a real implementation, you might want more granular control
      }
    } catch (e) {
      setState(() => _tawseyaNotifications = !_tawseyaNotifications);
      _showErrorSnackBar('خطأ في تحديث إشعارات التوصية');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationHelper.of(context).profile_notification_settings),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Main notification toggle
                Card(
                  child: ListTile(
                    title: const Text(
                      'تفعيل الإشعارات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'تلقي إشعارات حول الطلبات وتحديثات التوصية',
                    ),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (_) => _toggleNotifications(),
                      activeColor: const Color(0xFFDC2626),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Order notifications
                Card(
                  child: ListTile(
                    title: const Text(
                      'إشعارات الطلبات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'تحديثات حالة الطلب والتوصيل',
                    ),
                    trailing: Switch(
                      value: _orderNotifications && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? _updateOrderNotifications : null,
                      activeColor: const Color(0xFFDC2626),
                    ),
                    enabled: _notificationsEnabled,
                  ),
                ),

                const SizedBox(height: 16),

                // Tawseya notifications
                Card(
                  child: ListTile(
                    title: const Text(
                      'إشعارات التوصية',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'تذكيرات التصويت والنتائج',
                    ),
                    trailing: Switch(
                      value: _tawseyaNotifications && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? _updateTawseyaNotifications : null,
                      activeColor: const Color(0xFFDC2626),
                    ),
                    enabled: _notificationsEnabled,
                  ),
                ),

                const SizedBox(height: 16),

                // Promotional notifications
                Card(
                  child: ListTile(
                    title: const Text(
                      'العروض والتخفيضات',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'عروض خاصة وتخفيضات من المطاعم',
                    ),
                    trailing: Switch(
                      value: _promotionalNotifications && _notificationsEnabled,
                      onChanged: _notificationsEnabled ? (value) => setState(() => _promotionalNotifications = value) : null,
                      activeColor: const Color(0xFFDC2626),
                    ),
                    enabled: _notificationsEnabled,
                  ),
                ),

                const SizedBox(height: 32),

                // Notification settings button
                if (_notificationsEnabled) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => NotificationPermissionsService.openNotificationSettings(),
                      icon: const Icon(Icons.settings),
                      label: const Text('إعدادات النظام'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Information text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ملاحظة: يمكنك التحكم في أنواع الإشعارات المختلفة من هنا. '
                    'للحصول على أفضل تجربة، ننصح بتفعيل إشعارات الطلبات وتحديثات التوصية.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}