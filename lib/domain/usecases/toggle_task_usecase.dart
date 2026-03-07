import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class ToggleTaskUseCase {
  final TaskRepository repository;
  ToggleTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    return repository.updateTask(updated);
  }
}
