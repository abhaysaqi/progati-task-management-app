import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';

class AddTaskPage extends StatefulWidget {
  final TaskEntity? existingTask;

  const AddTaskPage({super.key, this.existingTask});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Priority _priority = Priority.medium;
  DateTime? _dueDate;
  DateTime? _reminderTime;
  bool _setReminder = true;
  int? _reminderOffsetHours = 3;

  bool get _isEditing => widget.existingTask != null;

  void _updateReminderTime() {
    if (_reminderOffsetHours != null) {
      if (_dueDate != null) {
        final baseDueDate =
            DateTime(_dueDate!.year, _dueDate!.month, _dueDate!.day, 23, 59);
        _reminderTime =
            baseDueDate.subtract(Duration(hours: _reminderOffsetHours!));
      } else {
        _reminderTime =
            DateTime.now().add(Duration(hours: _reminderOffsetHours!));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final task = widget.existingTask!;
      _titleController.text = task.title;
      _descriptionController.text = task.description;
      _priority = task.priority;
      _dueDate = task.dueDate;
      _reminderTime = task.reminderTime;
      _setReminder = task.reminderTime != null;
      _reminderOffsetHours = null;
    } else {
      _updateReminderTime();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme:
              Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _updateReminderTime();
      });
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showDateTimePicker(context);
    if (picked != null) {
      setState(() {
        _reminderOffsetHours = null;
        _reminderTime = picked;
      });
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<TaskBloc>();
    final title = _titleController.text.trim();

    if (bloc.state is TaskLoaded) {
      final currentState = bloc.state as TaskLoaded;
      final isDuplicate = currentState.allTasks.any((t) {
        if (_isEditing && t.id == widget.existingTask!.id) return false;
        return t.title.toLowerCase() == title.toLowerCase();
      });

      if (isDuplicate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A task with this title already exists.', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.priorityHigh,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    if (_isEditing) {
      final updated = widget.existingTask!.copyWith(
        title: title,
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        reminderTime: _setReminder ? _reminderTime : null,
        clearReminderTime: !_setReminder,
        clearDueDate: _dueDate == null,
      );
      bloc.add(UpdateTaskEvent(updated));
    } else {
      final task = TaskEntity(
        id: const Uuid().v4(),
        title: title,
        description: _descriptionController.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
        createdAt: DateTime.now(),
        reminderTime: _setReminder ? _reminderTime : null,
      );
      bloc.add(AddTaskEvent(task));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button + title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        _isEditing ? 'Edit Task' : 'New Task',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),
                  const SizedBox(height: 32),
                  // Title field
                  const _SectionLabel(label: 'Task Title'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'What do you need to do?',
                      prefixIcon: Icon(Icons.task_alt_rounded,
                          color: AppColors.primary),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Title is required'
                        : null,
                    onChanged: (v) {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() {});
                      }
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ).animate().fadeIn(delay: 50.ms).slideX(begin: 0.05),
                  const SizedBox(height: 20),
                  // Description field
                  const _SectionLabel(label: 'Description (optional)'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Add some details...',
                      // prefixIcon:
                      //     Icon(Icons.notes_rounded, color: AppColors.primary),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05),
                  const SizedBox(height: 24),
                  // Priority
                  const _SectionLabel(label: 'Priority'),
                  const SizedBox(height: 12),
                  _PrioritySelector(
                    selected: _priority,
                    onChanged: (p) => setState(() => _priority = p),
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 24),
                  // Due date
                  const _SectionLabel(label: 'Due Date'),
                  const SizedBox(height: 10),
                  _DatePickerTile(
                    icon: Icons.calendar_today_rounded,
                    label: _dueDate != null
                        ? DateFormat('EEE, MMM d yyyy').format(_dueDate!)
                        : 'Set due date',
                    isSet: _dueDate != null,
                    onTap: _pickDueDate,
                    onClear: () => setState(() => _dueDate = null),
                    isDark: isDark,
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 20),
                  // Reminder
                  const _SectionLabel(label: 'Reminder'),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Enable reminder',
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: _setReminder && _reminderTime != null
                          ? Text(
                              DateFormat('EEE, MMM d • h:mm a')
                                  .format(_reminderTime!),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : null,
                      value: _setReminder,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() {
                          _setReminder = val;
                          if (val && _reminderTime == null) {
                            _reminderOffsetHours = 3;
                            _updateReminderTime();
                          }
                        });
                      },
                    ),
                  ).animate().fadeIn(delay: 250.ms),
                  if (_setReminder) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ReminderChip(
                          label: _dueDate != null ? '3h Before' : '+3 Hours',
                          isSelected: _reminderOffsetHours == 3,
                          isDark: isDark,
                          onTap: () => setState(() {
                            _reminderOffsetHours = 3;
                            _updateReminderTime();
                          }),
                        ),
                        _ReminderChip(
                          label: _dueDate != null ? '12h Before' : '+12 Hours',
                          isSelected: _reminderOffsetHours == 12,
                          isDark: isDark,
                          onTap: () => setState(() {
                            _reminderOffsetHours = 12;
                            _updateReminderTime();
                          }),
                        ),
                        _ReminderChip(
                          label: _dueDate != null ? '1d Before' : '+1 Day',
                          isSelected: _reminderOffsetHours == 24,
                          isDark: isDark,
                          onTap: () => setState(() {
                            _reminderOffsetHours = 24;
                            _updateReminderTime();
                          }),
                        ),
                        _ReminderChip(
                          label: 'Custom',
                          icon: Icons.access_time_rounded,
                          isSelected: _reminderOffsetHours == null,
                          isDark: isDark,
                          onTap: _pickReminderTime,
                        ),
                      ],
                    ).animate().fadeIn().slideX(begin: -0.05),
                  ],
                  const SizedBox(height: 40),
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTask,
                      child: Text(_isEditing ? 'Update Task' : 'Save Task'),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.3, end: 0, curve: Curves.elasticOut),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> showDateTimePicker(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme:
            Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
      ),
      child: child!,
    ),
  );
  if (date == null || !context.mounted) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (ctx, child) => Theme(
      data: Theme.of(ctx).copyWith(
        colorScheme:
            Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
      ),
      child: child!,
    ),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

class _ReminderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;
  final IconData? icon;

  const _ReminderChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.primary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final Priority selected;
  final ValueChanged<Priority> onChanged;

  const _PrioritySelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Priority.values.map((p) {
        final isSelected = selected == p;
        final color = p == Priority.high
            ? AppColors.priorityHigh
            : p == Priority.medium
                ? AppColors.priorityMedium
                : AppColors.priorityLow;
        final label = p.name[0].toUpperCase() + p.name.substring(1);
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Icon(
                    p == Priority.high
                        ? Icons.keyboard_double_arrow_up_rounded
                        : p == Priority.medium
                            ? Icons.remove_rounded
                            : Icons.keyboard_double_arrow_down_rounded,
                    color: isSelected ? Colors.white : color,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSet;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool isDark;

  const _DatePickerTile({
    required this.icon,
    required this.label,
    required this.isSet,
    required this.onTap,
    required this.onClear,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSet ? AppColors.primary.withOpacity(0.4) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSet
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.5)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSet
                      ? AppColors.primary
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: isSet ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSet)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close_rounded,
                    size: 18, color: AppColors.primary.withOpacity(0.6)),
              ),
          ],
        ),
      ),
    );
  }
}
