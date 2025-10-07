import 'restaurant_status_type.dart';
import 'working_hours.dart';

class RestaurantStatus {
  const RestaurantStatus({
    required this.statusType,
    required this.workingHours,
    this.reason,
    this.estimatedReopening,
    this.lastUpdated,
    this.updatedBy,
  });

  factory RestaurantStatus.fromJson(Map<String, dynamic> json) {
    return RestaurantStatus(
      statusType: RestaurantStatusType.values.firstWhere(
        (type) => type.name == json['statusType'],
        orElse: () => RestaurantStatusType.closed,
      ),
      workingHours: WorkingHours.fromJson(json['workingHours'] ?? {}),
      reason: json['reason'] as String?,
      estimatedReopening: json['estimatedReopening'] != null
          ? DateTime.parse(json['estimatedReopening'] as String)
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      updatedBy: json['updatedBy'] as String?,
    );
  }

  final RestaurantStatusType statusType;
  final WorkingHours workingHours;
  final String? reason;
  final DateTime? estimatedReopening;
  final DateTime? lastUpdated;
  final String? updatedBy;

  bool get isOpen {
    if (!statusType.isOperational) return false;
    return workingHours.isOpenAt(DateTime.now());
  }

  bool get isCurrentlyOpen {
    return statusType.isOperational && workingHours.isOpenAt(DateTime.now());
  }

  String? getNextOpenTime() {
    if (statusType.isOperational) {
      return workingHours.getNextOpenTime(DateTime.now());
    }
    return null;
  }

  String getDisplayMessage(String languageCode) {
    final statusName = statusType.getDisplayName(languageCode);

    if (statusType == RestaurantStatusType.open) {
      if (isCurrentlyOpen) {
        return languageCode == 'ar' ? 'مفتوح الآن' : 'Open Now';
      } else {
        final nextOpen = getNextOpenTime();
        if (nextOpen != null) {
          return languageCode == 'ar'
              ? 'يفتح في $nextOpen'
              : 'Opens at $nextOpen';
        }
        return languageCode == 'ar' ? 'مغلق الآن' : 'Closed Now';
      }
    }

    if (statusType.isTemporarilyUnavailable) {
      if (estimatedReopening != null) {
        return languageCode == 'ar'
            ? '$statusName - يعاد الافتتاح ${estimatedReopening.toString()}'
            : '$statusName - Reopens ${estimatedReopening.toString()}';
      }
      return statusName;
    }

    if (statusType.isPermanentlyUnavailable) {
      return statusName;
    }

    return statusName;
  }

  RestaurantStatus copyWith({
    RestaurantStatusType? statusType,
    WorkingHours? workingHours,
    String? reason,
    DateTime? estimatedReopening,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return RestaurantStatus(
      statusType: statusType ?? this.statusType,
      workingHours: workingHours ?? this.workingHours,
      reason: reason ?? this.reason,
      estimatedReopening: estimatedReopening ?? this.estimatedReopening,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  Map<String, dynamic> toJson() => {
        'statusType': statusType.name,
        'workingHours': workingHours.toJson(),
        'reason': reason,
        'estimatedReopening': estimatedReopening?.toIso8601String(),
        'lastUpdated': lastUpdated?.toIso8601String(),
        'updatedBy': updatedBy,
      };
}