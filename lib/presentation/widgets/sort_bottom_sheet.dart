import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/task/task_event.dart';

class SortBottomSheet extends StatelessWidget {
  final SortOption currentSort;
  final Function(SortOption) onSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final options = [
      const _SortOption(
        icon: Icons.calendar_today_rounded,
        label: 'Date Created',
        sort: SortOption.date,
        color: AppColors.accentBlue,
      ),
      const _SortOption(
        icon: Icons.flag_rounded,
        label: 'Priority',
        sort: SortOption.priority,
        color: AppColors.priorityHigh,
      ),
      const _SortOption(
        icon: Icons.sort_by_alpha_rounded,
        label: 'Alphabetical',
        sort: SortOption.alphabetical,
        color: AppColors.accentGreen,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sort Tasks',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...options.map((opt) {
            final isSelected = currentSort == opt.sort;
            return GestureDetector(
              onTap: () {
                onSelected(opt.sort);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? opt.color.withOpacity(0.12)
                      : (isDark ? AppColors.darkCard : AppColors.background),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? opt.color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: opt.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(opt.icon, color: opt.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      opt.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? opt.color : null,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: opt.color, size: 22),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 200.ms, delay: (options.indexOf(opt) * 60).ms)
                .slideX(begin: 0.1, end: 0);
          }),
        ],
      ),
    );
  }
}

class _SortOption {
  final IconData icon;
  final String label;
  final SortOption sort;
  final Color color;
  const _SortOption({
    required this.icon,
    required this.label,
    required this.sort,
    required this.color,
  });
}
