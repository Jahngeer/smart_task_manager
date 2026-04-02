class Task {
  int? id;
  String title;
  String date;
  bool isDone;

  Task({
    this.id,
    required this.title,
    this.date = "",
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'isDone': isDone ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      isDone: map['isDone'] == 1,
    );
  }
}