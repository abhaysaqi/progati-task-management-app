import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                    'Privacy Policy',
                    style: theme.textTheme.headlineSmall,
                  ),
                ],
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),
              const SizedBox(height: 32),
              Text(
                'Your Data is Yours',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 16),
              Text(
                '''1. Local Storage Only
At Progati, we believe in privacy by design. All of your task data, reminders, and application settings are stored locally on your device using an encrypted local database (Hive).

2. No Cloud Syncing
We do not upload, sync, or transmit any of your personal task data to any external servers or third-party cloud providers.

3. Complete Control
You have absolute control over your data. You can delete individual tasks or clear your entire data stored by the app at any time through the Settings page.

4. Device Permissions
We only request notifications permission exclusively to send you timely reminders for the tasks that you explicitly create. We do not track your location, access your contacts, or read files outside the app's secure directory.

If you have any questions about how your data is handled, feel free to inspect the open-source architecture or clear your app data directly.''',
                style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
