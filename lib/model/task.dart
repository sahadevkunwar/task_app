class TaskModel {
  String? id;
  String title;
  String status;

  TaskModel({
    this.id,
    required this.title,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'title': title,
      'status': status,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['_id'] as String,
      title: map['title'] as String,
      status: map['status'],
    );
  }
}
