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

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['usermane'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: json['avatar_url'],
      place: json['place'],
      domain: json['domain'],
      bio: json['bio'],
    );
  }
}