import 'package:flutter/material.dart';
import '../../../../core/services/firebase/firebase_messaging_service.dart';
import '../entities/tawseya_item.dart';
import '../entities/voting_period.dart';

class TawseyaNotificationService {
  // Send notification when voting period starts
  static Future<void> sendVotingPeriodStartedNotification({
    required VotingPeriod votingPeriod,
    String? imageUrl,
  }) async {
    final title = 'بدأ التصويت في توصية الشهر!';
    final body = 'ابدأ التصويت الآن في أفضل المطاعم والأطباق لهذا الشهر';

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      type: 'voting_period_started',
    );
  }

  // Send notification when voting period is ending soon
  static Future<void> sendVotingEndingSoonNotification({
    required VotingPeriod votingPeriod,
    required int hoursRemaining,
    String? imageUrl,
  }) async {
    final title = 'تذكير: التصويت ينتهي قريباً!';
    final body = 'تبقى $hoursRemaining ساعة فقط للتصويت في توصية الشهر. لا تفوت الفرصة!';

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      type: 'voting_ending_soon',
      hoursRemaining: hoursRemaining,
    );
  }

  // Send notification when voting period ends
  static Future<void> sendVotingPeriodEndedNotification({
    required VotingPeriod votingPeriod,
    String? imageUrl,
  }) async {
    final title = 'انتهى التصويت في توصية الشهر';
    final body = 'شكراً لمشاركتك في التصويت. ستعلن النتائج قريباً!';

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      type: 'voting_period_ended',
    );
  }

  // Send notification for voting results
  static Future<void> sendVotingResultsNotification({
    required VotingPeriod votingPeriod,
    required List<TawseyaItem> topItems,
    String? imageUrl,
  }) async {
    final title = 'نتائج توصية الشهر!';
    String body;

    if (topItems.isNotEmpty) {
      final winner = topItems.first;
      body = 'فاز "${winner.name}" بلقب أفضل طبق لهذا الشهر!';
    } else {
      body = 'لم يتم التصويت على أي عناصر في هذه الفترة';
    }

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      type: 'voting_results',
      topItemName: topItems.isNotEmpty ? topItems.first.name : null,
    );
  }

  // Send reminder to vote for specific items
  static Future<void> sendVoteReminderNotification({
    required TawseyaItem tawseyaItem,
    required VotingPeriod votingPeriod,
    String? imageUrl,
  }) async {
    final title = 'تذكير بالتصويت';
    final body = 'هل جربت "${tawseyaItem.name}"؟ شاركنا رأيك بالتصويت!';

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      imageUrl: imageUrl ?? tawseyaItem.imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: votingPeriod.id,
      type: 'vote_reminder',
      tawseyaItemId: tawseyaItem.id,
    );
  }

  // Send notification for new Tawseya items
  static Future<void> sendNewTawseyaItemNotification({
    required TawseyaItem tawseyaItem,
    String? imageUrl,
  }) async {
    final title = 'عنصر جديد في التوصية!';
    final body = 'تم إضافة "${tawseyaItem.name}" إلى قائمة التوصية. اكتشفه الآن!';

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      votingPeriodId: tawseyaItem.id, // Using item ID as period ID for this case
      imageUrl: imageUrl ?? tawseyaItem.imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: tawseyaItem.id,
      type: 'new_tawseya_item',
      tawseyaItemId: tawseyaItem.id,
    );
  }

  // Send notification for user's voting milestone
  static Future<void> sendVotingMilestoneNotification({
    required int voteCount,
    String? imageUrl,
  }) async {
    String title;
    String body;

    if (voteCount == 1) {
      title = 'أول تصويت لك!';
      body = 'شكراً لمشاركتك في أول تصويت لك في التوصية';
    } else if (voteCount == 5) {
      title = 'مشارك نشط!';
      body = 'لقد قمت بالتصويت 5 مرات! استمر في مشاركتك';
    } else if (voteCount == 10) {
      title = 'خبير التوصية!';
      body = 'وصلت إلى 10 تصويتات! رأيك مهم للمجتمع';
    } else {
      title = 'مشاركة مستمرة!';
      body = 'لقد قمت بالتصويت $voteCount مرة! شكراً لمشاركتك الفعالة';
    }

    await FirebaseMessagingService.showTawseyaNotification(
      title: title,
      body: body,
      imageUrl: imageUrl,
    );

    await _sendToCloudMessaging(
      title: title,
      body: body,
      votingPeriodId: 'general',
      type: 'voting_milestone',
      voteCount: voteCount,
    );
  }

  // Subscribe user to Tawseya notifications
  static Future<void> subscribeToTawseyaNotifications() async {
    await FirebaseMessagingService.subscribeToTawseyaNotifications();
  }

  // Unsubscribe user from Tawseya notifications
  static Future<void> unsubscribeFromTawseyaNotifications() async {
    await FirebaseMessagingService.unsubscribeFromTawseyaNotifications();
  }

  // Send notification to Firebase Cloud Messaging (for cross-device sync)
  static Future<void> _sendToCloudMessaging({
    required String title,
    required String body,
    required String votingPeriodId,
    required String type,
    String? tawseyaItemId,
    String? topItemName,
    int? hoursRemaining,
    int? voteCount,
  }) async {
    try {
      // TODO: Implement Firebase Cloud Messaging API call
      // This would typically be done through a Cloud Function or your backend
      print('Would send to FCM: $title - $body for voting period $votingPeriodId with type $type');
    } catch (e) {
      print('Error sending to FCM: $e');
    }
  }

  // Get notification icon based on Tawseya notification type
  static IconData getNotificationIcon(String type) {
    switch (type) {
      case 'voting_period_started':
        return Icons.how_to_vote;
      case 'voting_ending_soon':
        return Icons.alarm;
      case 'voting_period_ended':
        return Icons.done_all;
      case 'voting_results':
        return Icons.emoji_events;
      case 'vote_reminder':
        return Icons.notifications;
      case 'new_tawseya_item':
        return Icons.add_circle;
      case 'voting_milestone':
        return Icons.star;
      default:
        return Icons.how_to_vote;
    }
  }

  // Get notification color based on Tawseya notification type
  static Color getNotificationColor(String type) {
    switch (type) {
      case 'voting_period_started':
        return Colors.green;
      case 'voting_ending_soon':
        return Colors.orange;
      case 'voting_period_ended':
        return Colors.blue;
      case 'voting_results':
        return Colors.amber;
      case 'vote_reminder':
        return Colors.purple;
      case 'new_tawseya_item':
        return Colors.teal;
      case 'voting_milestone':
        return Colors.pink;
      default:
        return Colors.orange;
    }
  }
}