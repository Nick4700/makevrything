class App {
  final String id;
  final String name;
  String htmlContent;
  final String templateId;
  final DateTime createdAt;
  DateTime updatedAt;

  App({
    required this.id,
    required this.name,
    required this.htmlContent,
    required this.templateId,
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'htmlContent': htmlContent,
        'templateId': templateId,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory App.fromJson(Map<String, dynamic> json) => App(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        htmlContent: json['htmlContent'] ?? '',
        templateId: json['templateId'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
      );

  App copyWith({String? htmlContent, String? name}) => App(
        id: id,
        name: name ?? this.name,
        htmlContent: htmlContent ?? this.htmlContent,
        templateId: templateId,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
