import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/models/todo_model.dart';

class DialogService {
  void showEditDialog(Todo todo, Function(Todo) onUpdate) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.description);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                Get.back();
                final updatedTodo = todo.copyWith(
                  title: title,
                  description: descController.text.trim(),
                );
                onUpdate(updatedTodo);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void showStatusDialog(
    Todo todo,
    Function(String, TodoStatus) onStatusUpdate,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TodoStatus.values.map((status) {
            return ListTile(
              title: Text(status.displayName),
              leading: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: () {
                Get.back();
                onStatusUpdate(todo.id, status);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void showDeleteDialog(Todo todo, Function(String) onDelete) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              onDelete(todo.id);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void handleMenuAction(
    String action,
    Todo todo,
    Function(Todo) onUpdate,
    Function(String, TodoStatus) onStatusUpdate,
    Function(String) onDelete,
  ) {
    switch (action) {
      case 'edit':
        showEditDialog(todo, onUpdate);
        break;
      case 'status':
        showStatusDialog(todo, onStatusUpdate);
        break;
      case 'delete':
        showDeleteDialog(todo, onDelete);
        break;
    }
  }
}
