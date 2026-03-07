import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity?> getTaskById(String id);
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> clearAllTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> _box;

  TaskLocalDataSourceImpl(this._box);

  @override
  Future<List<TaskEntity>> getTasks() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    try {
      return _box.values
          .firstWhere((m) => m.id == id)
          .toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _box.put(task.id, model);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _box.put(task.id, model);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAllTasks() async {
    await _box.clear();
  }
}
