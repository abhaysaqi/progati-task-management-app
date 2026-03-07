import '../entities/task_entity.dart';

class SearchTasksUseCase {
  SearchTasksUseCase();

  List<TaskEntity> call(List<TaskEntity> tasks, String query) {
    if (query.isEmpty) return tasks;
    final lower = query.toLowerCase();
    return tasks
        .where((t) =>
            t.title.toLowerCase().contains(lower) ||
            t.description.toLowerCase().contains(lower))
        .toList();
  }
}
