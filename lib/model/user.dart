class UserFields {
  static final List<String> values = [
    id,
    username,
    profilePictureUrl,
    createdAt,
    updatedAt,
  ];

  static const String id = 'id';
  static const String username = 'username';
  static const String profilePictureUrl = 'profile_picture_url';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class User {
  final int id;
  final String username;
  final String profilePictureUrl;
  final String createdAt;
  final String updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.profilePictureUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  User copy({
    int? id,
    String? username,
    String? profilePictureUrl,
    String? createdAt,
    String? updatedAt,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  static User fromJson(Map<String, Object?> json) => User(
        id: json[UserFields.id] as int,
        username: json[UserFields.username] as String,
        profilePictureUrl: json[UserFields.profilePictureUrl] as String,
        createdAt: json[UserFields.createdAt] as String,
        updatedAt: json[UserFields.updatedAt] as String,
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.username: username,
        UserFields.profilePictureUrl: profilePictureUrl,
        UserFields.createdAt: createdAt,
        UserFields.updatedAt: updatedAt,
      };
}
