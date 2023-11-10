class Task {
   String id; // Add an ID field
  final String title;
  final String description;
  final DateTime date;
  final Category category;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.isDone = false,
  });
}


enum Category {
  personal,
  work,
  study,
  other,
}

