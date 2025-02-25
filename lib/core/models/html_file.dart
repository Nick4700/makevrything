class HtmlFile {
  final String id;
  final String name;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isTemplate;

  HtmlFile({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isTemplate = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isTemplate': isTemplate,
      };

  factory HtmlFile.fromJson(Map<String, dynamic> json) => HtmlFile(
        id: json['id'],
        name: json['name'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isTemplate: json['isTemplate'] ?? false,
      );
}
