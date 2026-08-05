class UserProfile {
  final String id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? place;
  final String? domain;
  final String? bio;

  UserProfile({
    required this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.place,
    this.domain,
    this.bio,
  });

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'username': username,
    'first_name': firstName,
    'last_name': lastName,
    'avatar_url': avatarUrl,
    'place': place,
    'domain': domain,
    'bio': bio,
  };
}

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: json['avatar_url'],
      place: json['place'],
      domain: json['domain'],
      bio: json['bio'],
    );
  }

  Object? get createdAt => null;
}