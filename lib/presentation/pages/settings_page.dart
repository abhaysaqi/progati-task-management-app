import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_event.dart';
import '../blocs/settings/settings_state.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    'Settings',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),
              const SizedBox(height: 32),
              // App info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Image.asset("assets/images/progati_logo.png")),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progati',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .scale(begin: const Offset(0.95, 0.95)),
              const SizedBox(height: 28),
              Text(
                'Appearance',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 12),
              // Dark mode toggle
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return _SettingsTile(
                    icon: state.isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    iconColor: state.isDark
                        ? AppColors.primaryLight
                        : AppColors.accentOrange,
                    title: 'Dark Mode',
                    subtitle:
                        state.isDark ? 'Currently dark' : 'Currently light',
                    isDark: isDark,
                    trailing: Switch(
                      value: state.isDark,
                      activeThumbColor: AppColors.primary,
                      onChanged: (_) => context
                          .read<SettingsBloc>()
                          .add(const ToggleThemeEvent()),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
              const SizedBox(height: 28),
              Text(
                'About',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 250.ms),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.info_rounded,
                iconColor: AppColors.accentBlue,
                title: 'About App',
                subtitle: 'Learn more about Progati',
                isDark: isDark,
                onTap: () => context.push('/about'),
              ).animate().fadeIn(delay: 280.ms).slideX(begin: 0.05),
              const SizedBox(height: 10),
              _SettingsTile(
                icon: Icons.privacy_tip_rounded,
                iconColor: AppColors.accentGreen,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                isDark: isDark,
                onTap: () => context.push('/privacy'),
              ).animate().fadeIn(delay: 310.ms).slideX(begin: 0.05),
              const SizedBox(height: 32),
              Text(
                'Data',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ).animate().fadeIn(delay: 360.ms),
              const SizedBox(height: 12),
              _SettingsTile(
                icon: Icons.delete_forever_rounded,
                iconColor: AppColors.error,
                title: 'Clear All Data',
                subtitle: 'Permanently delete all tasks',
                isDark: isDark,
                onTap: () => _showClearDataConfirmation(context),
              ).animate().fadeIn(delay: 390.ms).slideX(begin: 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showClearDataConfirmation(BuildContext context) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your tasks and reminders. This action cannot be undone.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: theme.hintColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<TaskBloc>().add(const ClearAllTasksEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('All data cleared successfully.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
