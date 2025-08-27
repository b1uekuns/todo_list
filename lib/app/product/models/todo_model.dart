import 'package:flutter/material.dart';

class Todo {
  String id;
  String title;
  String description;
  bool done;
  DateTime createdDate;
  DateTime? dueDate;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.done = false,
    required this.createdDate,
    this.dueDate,
    this.status = TodoStatus.ongoing,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? done,
    DateTime? createdDate,
    DateTime? dueDate,
    TodoStatus? status,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      done: done ?? this.done,
      createdDate: createdDate ?? this.createdDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'done': done,
    'createdDate': createdDate.millisecondsSinceEpoch,
    'dueDate': dueDate?.millisecondsSinceEpoch,
    'status': status.name,
  };

  factory Todo.fromMap(Map<String, dynamic> m) => Todo(
    id: m['id'],
    title: m['title'],
    description: m['description'] ?? '',
    done: m['done'] ?? false,
    createdDate: DateTime.fromMillisecondsSinceEpoch(
      m['createdDate'] ?? DateTime.now().millisecondsSinceEpoch,
    ),
    dueDate: m['dueDate'] != null
        ? DateTime.fromMillisecondsSinceEpoch(m['dueDate'])
        : null,
    status: TodoStatus.values.firstWhere(
      (e) => e.name == m['status'],
      orElse: () => TodoStatus.ongoing,
    ),
  );
}
enum TodoStatus { ongoing, inProcess, complete, canceled }

extension TodoStatusExtension on TodoStatus {
  String get displayName {
    switch (this) {
      case TodoStatus.ongoing:
        return 'On Going';
      case TodoStatus.inProcess:
        return 'In Process';
      case TodoStatus.complete:
        return 'Complete';
      case TodoStatus.canceled:
        return 'Canceled';
    }
  }

  Color get color {
    switch (this) {
      case TodoStatus.ongoing:
        return Colors.blue;
      case TodoStatus.inProcess:
        return Colors.orange;
      case TodoStatus.complete:
        return Colors.green;
      case TodoStatus.canceled:
        return Colors.red;
    }
  }
}
