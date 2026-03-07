import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(const LoadTasksEvent());
    _searchController.addListener(() {
      context.read<TaskBloc>().add(SearchTasksEvent(_searchController.text));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(BuildContext ctx, String taskId, String title) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Task?'),
        content: Text(
          'Are you sure you want to delete "$title"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.priorityHigh,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              ctx.read<TaskBloc>().add(DeleteTaskEvent(taskId));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Tasks ✨',
                                  style: theme.textTheme.headlineMedium,
                                )
                                    .animate()
                                    .fadeIn(duration: 400.ms)
                                    .slideY(begin: -0.2, end: 0),
                                BlocBuilder<TaskBloc, TaskState>(
                                  builder: (context, state) {
                                    if (state is TaskLoaded) {
                                      return Text(
                                        '${state.completedCount}/${state.allTasks.length} completed',
                                        style: theme.textTheme.bodyMedium,
                                      ).animate().fadeIn(
                                          duration: 400.ms, delay: 100.ms);
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Settings button
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.settings),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkCard
                                    : AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.settings_rounded,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms)
                              .scale(begin: const Offset(0.8, 0.8)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Stats row
                      BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          if (state is! TaskLoaded) return const SizedBox();
                          return Row(
                            children: [
                              _StatChip(
                                label: 'Pending',
                                count: state.pendingCount,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              _StatChip(
                                label: 'Done',
                                count: state.completedCount,
                                color: AppColors.accentGreen,
                              ),
                            ],
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
                        },
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      _SearchBar(controller: _searchController, isDark: isDark),
                      const SizedBox(height: 16),
                      // Sort row
                      BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          final sort = state is TaskLoaded
                              ? state.sortOption
                              : SortOption.date;
                          return Row(
                            children: [
                              Text(
                                'All Tasks',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => SortBottomSheet(
                                      currentSort: sort,
                                      onSelected: (s) => context
                                          .read<TaskBloc>()
                                          .add(SortTasksEvent(s)),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkCard
                                        : AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.filter_list_rounded,
                                          size: 16, color: AppColors.primary),
                                      SizedBox(width: 6),
                                      Text(
                                        'Sort',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              // Task List
              BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading || state is TaskInitial) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (state is TaskError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${state.message}')),
                    );
                  }

                  if (state is TaskLoaded) {
                    if (state.displayedTasks.isEmpty) {
                      return const SliverFillRemaining(
                          child: EmptyStateWidget());
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final task = state.displayedTasks[i];
                            return TaskCard(
                              task: task,
                              onToggle: () => context
                                  .read<TaskBloc>()
                                  .add(ToggleTaskEvent(task)),
                              onTap: () => context.push(
                                '/task/${task.id}',
                                extra: task,
                              ),
                              onDelete: () => _showDeleteConfirmation(
                                context,
                                task.id,
                                task.title,
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 300.ms,
                                  delay: (i * 50).ms,
                                )
                                .slideX(begin: 0.05, end: 0);
                          },
                          childCount: state.displayedTasks.length,
                        ),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox());
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.addTask),
          label: const Text(
            'Add Task',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          icon: const Icon(Icons.add_rounded, size: 24),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        )
            .animate()
            .slideY(begin: 1, end: 0, delay: 400.ms, curve: Curves.elasticOut)
            .fadeIn(delay: 400.ms),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count $label',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const _SearchBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            autofocus: false,
            focusNode: FocusNode(), // Ensures an active focus node isn't retained implicitly
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: Icon(Icons.search_rounded,
                  color: AppColors.primary.withOpacity(0.7)),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: controller.clear,
                    )
                  : null,
              // border: InputBorder.none,
              // enabledBorder: InputBorder.none,
              // focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          );
        },
      ),
    );
  }
}
