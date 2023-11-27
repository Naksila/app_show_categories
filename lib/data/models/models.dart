import 'dart:convert';

import 'package:app_show_categories/domain/domain.dart';

class ToDoListModel {
  final List<Task>? tasks;
  final int? pageNumber;
  final int? totalPages;

  ToDoListModel({
    required this.tasks,
    required this.pageNumber,
    required this.totalPages,
  });

  TodoListEntity toEntity({ToDoListModel? toDoListModel}) {
    return TodoListEntity(
      // tasks: TaskEntity(
      //   title: toDoListModel.tasks.map((e) => e.title).toList(),
      // ),
      tasks: toDoListModel?.tasks
          ?.map(
            (e) => TaskEntity(
                id: e.id,
                title: e.title,
                description: e.description,
                createdAt: e.createdAt,
                status: e.status),
          )
          .toList(),
      pageNumber: toDoListModel?.pageNumber,
      totalPages: toDoListModel?.totalPages,
    );
  }

  factory ToDoListModel.fromRawJson(String str) =>
      ToDoListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ToDoListModel.fromJson(Map<String, dynamic> json) => ToDoListModel(
        tasks: json["tasks"] == null
            ? []
            : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
        pageNumber: json["pageNumber"],
        totalPages: json["totalPages"],
      );

  Map<String, dynamic> toJson() => {
        "tasks": tasks == null
            ? []
            : List<dynamic>.from(tasks!.map((x) => x.toJson())),
        "pageNumber": pageNumber,
        "totalPages": totalPages,
      };
}

class Task {
  String? id;
  String? title;
  String? description;
  DateTime? createdAt;
  Status? status;

  Task({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.status,
  });

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        status: statusValues.map[json["status"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "status": statusValues.reverse[status],
      };
}

enum Status { DOING, DONE, TODO }

final statusValues = EnumValues(
    {"DOING": Status.DOING, "DONE": Status.DONE, "TODO": Status.TODO});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
