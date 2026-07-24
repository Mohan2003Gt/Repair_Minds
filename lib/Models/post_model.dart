class PostModel {
  final int id;
  final String userId;
  final String title;
  final String subtitle;
  final String problem;
  final String imageUrl;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.subtitle,
    required this.problem,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      problem: json['problem'] ?? '',
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}