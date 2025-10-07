class User { // For guest/anonymous users

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt, this.phone,
    this.isVerified = false,
    this.isAnonymous = false, // Default to false for regular users
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );
  final String id;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final bool isVerified;
  final bool isAnonymous;

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    DateTime? createdAt,
    bool? isVerified,
    bool? isAnonymous,
  }) => User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'isAnonymous': isAnonymous,
    };
}
