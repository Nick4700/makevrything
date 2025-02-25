class LiveSite {
  final String id;
  final String name;
  final String htmlContent;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  LiveSite({
    required this.id,
    required this.name,
    required this.htmlContent,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'htmlContent': htmlContent,
        'url': url,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isActive': isActive,
      };

  factory LiveSite.fromJson(Map<String, dynamic> json) => LiveSite(
        id: json['id'],
        name: json['name'],
        htmlContent: json['htmlContent'],
        url: json['url'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isActive: json['isActive'] ?? true,
      );
}
