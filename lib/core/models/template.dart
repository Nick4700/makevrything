class Template {
  final String id;
  final String name;
  final String htmlContent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Template({
    required this.id,
    required this.name,
    required this.htmlContent,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'htmlContent': htmlContent,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Template.fromJson(Map<String, dynamic> json) => Template(
        id: json['id'],
        name: json['name'],
        htmlContent: json['htmlContent'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
