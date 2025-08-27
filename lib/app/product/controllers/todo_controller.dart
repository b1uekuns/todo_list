import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';
import '../../core/utils/date_utils.dart';
import '../../core/services/dialog_service.dart';
import 'auth_controller.dart';

class TodoController extends GetxController {
  final todos = <Todo>[].obs;
  final storage = GetStorage('todo_box');
  final DialogService _dialogService = DialogService();
  String? _currentUserId;
  late Worker _authWorker;

  @override
  void onInit() {
    super.onInit();
    _loadTodos();
    _authWorker = ever(Get.find<AuthController>().user, (User? user) {
      final newUserId = user?.uid;
      if (_currentUserId != newUserId) {
        _currentUserId = newUserId;
        _loadTodos(); 
      }
    });
  }

  @override
  void onClose() {
    _authWorker.dispose();
    super.onClose();
  }

  void add(
    String title, {
    String description = '',
    DateTime? dueDate,
    bool showSnackbar = true,
  }) {
    try {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdDate: DateTime.now(),
        dueDate: dueDate,
        status: TodoStatus.ongoing,
        done: false,
      );

      todos.add(newTodo);
      _saveTodos();
    } catch (e) {
      //
    }
  }

  void updateTodo(Todo updatedTodo) {
    try {
      final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
        _saveTodos();
      }
    } catch (e) {
      //
    }
  }

  void updateTodoStatus(String id, TodoStatus status) {
    try {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = todos[index].copyWith(
          status: status,
          done: status == TodoStatus.complete,
        );
        _saveTodos();
      }
    } catch (e) {
      //
    }
  }

  void toggle(String id) {
    try {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final todo = todos[index];
        final newDone = !todo.done;
        todos[index] = todo.copyWith(
          done: newDone,
          status: newDone ? TodoStatus.complete : TodoStatus.ongoing,
        );
        _saveTodos();
      }
    } catch (e) {
      //
    }
  }

  void remove(String id) {
    try {
      todos.removeWhere((todo) => todo.id == id);
      _saveTodos();
    } catch (e) {
      //
    }
  }

  void clearCompleted() {
    try {
      todos.removeWhere((todo) => todo.done);
      _saveTodos();
    } catch (e) {
      //
    }
  }

  List<Todo> getTodosForDate(DateTime date) {
    return todos.where((todo) {
      return AppDateUtils.isSameDay(todo.createdDate, date) ||
          (todo.dueDate != null && AppDateUtils.isSameDay(todo.dueDate!, date));
    }).toList();
  }

  int get totalTodos => todos.length;
  int get ongoingCount =>
      todos.where((todo) => todo.status == TodoStatus.ongoing).length;
  int get inProcessCount =>
      todos.where((todo) => todo.status == TodoStatus.inProcess).length;
  int get completedCount =>
      todos.where((todo) => todo.status == TodoStatus.complete).length;
  int get canceledCount =>
      todos.where((todo) => todo.status == TodoStatus.canceled).length;
  int get remaining => todos.where((todo) => !todo.done).length;

  void showEditDialog(Todo todo) {
    _dialogService.showEditDialog(todo, updateTodo);
  }

  void showStatusDialog(Todo todo) {
    _dialogService.showStatusDialog(todo, updateTodoStatus);
  }

  void showDeleteDialog(Todo todo) {
    _dialogService.showDeleteDialog(todo, remove);
  }

  void handleMenuAction(String action, Todo todo) {
    _dialogService.handleMenuAction(
      action,
      todo,
      updateTodo,
      updateTodoStatus,
      remove,
    );
  }

  void _loadTodos() {
    try {
      final String? userId = storage.read('current_user_id');
      final String storageKey = userId != null ? 'todos_$userId' : 'todos_demo';

      final List<dynamic>? todosData = storage.read(storageKey);
      if (todosData != null) {
        todos.value = todosData.map((json) => Todo.fromMap(json)).toList();
      }
    } catch (e) {
      //
    }
  }

  void _saveTodos() {
    try {
      final String? userId = storage.read('current_user_id');
      final String storageKey = userId != null ? 'todos_$userId' : 'todos_demo';

      final List<Map<String, dynamic>> todosData = todos
          .map((todo) => todo.toMap())
          .toList();
      storage.write(storageKey, todosData);
    } catch (e) {
      //
    }
  }
}
