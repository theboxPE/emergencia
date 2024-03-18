
class Event {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final String? imagePath;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'image_path': imagePath,
    };
  }
}