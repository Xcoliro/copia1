import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final NotificationService _notificationService = NotificationService();

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    _tasks = await _dbHelper.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final newTask = await _dbHelper.createTask(task);
    _tasks.add(newTask);
    if (task.reminderDateTime != null) {
      await _notificationService.scheduleTaskReminder(newTask);
    }
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await _dbHelper.updateTask(task);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      if (task.reminderDateTime != null) {
        await _notificationService.scheduleTaskReminder(task);
      } else {
        await _notificationService.cancelNotification(task.id!);
      }
      notifyListeners();
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await _dbHelper.deleteTask(task.id!);
      await _notificationService.cancelNotification(task.id!);
      _tasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: !task.isCompleted,
      reminderDateTime: task.reminderDateTime,
      createdAt: task.createdAt,
    );
    await updateTask(updatedTask);
  }

  Future<List<Task>> getTasksByDate(DateTime date) async {
    return await _dbHelper.getTasksByDate(date);
  }

  int get completedTasksCount => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasksCount => _tasks.where((task) => !task.isCompleted).length;
  
  double get completionRate {
    if (_tasks.isEmpty) return 0.0;
    return completedTasksCount / _tasks.length * 100;
  }
} 