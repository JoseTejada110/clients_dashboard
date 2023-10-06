class Faq {
  Faq({
    required this.id,
    required this.title,
  });
  String id;
  final String title;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json['id'],
        title: json['title'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
      };
}

class FaqStep {
  FaqStep({
    required this.id,
    required this.title,
    required this.description,
    required this.stepImage,
    required this.order,
  });
  String id;
  final String title;
  final String description;
  final String stepImage;
  final int order;

  factory FaqStep.fromJson(Map<String, dynamic> json) => FaqStep(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        stepImage: json['step_image'] ?? '',
        order: json['order'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'step_image': stepImage,
        'order': order,
      };
}
