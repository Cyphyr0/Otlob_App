import '../../../auth/domain/entities/user.dart' as auth_user;

class Profile {
  const Profile({
    required this.id,
    required this.userId,
    this.displayName,
    this.bio,
    this.phoneNumber,
    this.profileImageUrl,
    this.coverImageUrl,
    this.dateOfBirth,
    this.gender,
    this.location,
    this.preferences,
    this.socialLinks,
    this.isProfileComplete = false,
    this.completedOrders = 0,
    this.totalSpent = 0.0,
    this.favoriteCuisines = const [],
    this.dietaryRestrictions = const [],
    this.notificationsEnabled = true,
    this.emailNotifications = true,
    this.smsNotifications = true,
    this.pushNotifications = true,
    this.language = 'en',
    this.metadata = const {},
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      location: json['location'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>?,
      socialLinks: json['socialLinks'] as Map<String, dynamic>?,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      completedOrders: json['completedOrders'] as int? ?? 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      favoriteCuisines: (json['favoriteCuisines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryRestrictions: (json['dietaryRestrictions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      smsNotifications: json['smsNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );

  factory Profile.fromAuthUser(auth_user.User authUser) => Profile(
      id: '${authUser.id}_profile',
      userId: authUser.id,
      displayName: authUser.name != 'User' ? authUser.name : null,
      createdAt: authUser.createdAt,
      updatedAt: DateTime.now(),
    );

  final String id;
  final String userId;
  final String? displayName;
  final String? bio;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? location;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? socialLinks;
  final bool isProfileComplete;
  final int completedOrders;
  final double totalSpent;
  final List<String> favoriteCuisines;
  final List<String> dietaryRestrictions;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool smsNotifications;
  final bool pushNotifications;
  final String language;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;

  Profile copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? bio,
    String? phoneNumber,
    String? profileImageUrl,
    String? coverImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? location,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? socialLinks,
    bool? isProfileComplete,
    int? completedOrders,
    double? totalSpent,
    List<String>? favoriteCuisines,
    List<String>? dietaryRestrictions,
    bool? notificationsEnabled,
    bool? emailNotifications,
    bool? smsNotifications,
    bool? pushNotifications,
    String? language,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) => Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
      socialLinks: socialLinks ?? this.socialLinks,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      completedOrders: completedOrders ?? this.completedOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      favoriteCuisines: favoriteCuisines ?? this.favoriteCuisines,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      language: language ?? this.language,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'location': location,
      'preferences': preferences,
      'socialLinks': socialLinks,
      'isProfileComplete': isProfileComplete,
      'completedOrders': completedOrders,
      'totalSpent': totalSpent,
      'favoriteCuisines': favoriteCuisines,
      'dietaryRestrictions': dietaryRestrictions,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'pushNotifications': pushNotifications,
      'language': language,
      'metadata': metadata,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
}