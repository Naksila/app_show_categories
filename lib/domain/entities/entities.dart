import 'package:app_show_categories/data/models/models.dart';

class TodoListEntity {
  final List<TaskEntity>? tasks;
  final int? pageNumber;
  final int? totalPages;

  TodoListEntity({
    required this.tasks,
    required this.pageNumber,
    required this.totalPages,
  });
}

class TaskEntity {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final Status? status;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });
}
