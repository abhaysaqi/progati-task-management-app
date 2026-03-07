import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                        color: isDark ? AppColors.darkCard : AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'About App',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset("assets/images/progati_logo.png"),
                      ),
                    ).animate().scale(delay: 100.ms),
                    const SizedBox(height: 24),
                    Text(
                      'Progati',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Description',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              Text(
                'Progati is a modern, privacy-focused task management application designed to help you stay organized and boost your productivity without compromising your data. All your tasks and reminders are stored securely on your device.',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
