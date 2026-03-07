import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3D illustration using emoji + decorative circles
            Stack(
              alignment: Alignment.center,
              children: [
                // Background glow
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.primary.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                // Outer ring
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                      width: 2,
                    ),
                  ),
                ),
                // Inner ring
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isDark ? AppColors.darkCard : AppColors.primarySurface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '📋',
                      style: TextStyle(fontSize: 44),
                    ),
                  ),
                ),
                // Floating decorations
                Positioned(
                  top: 8,
                  right: 20,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentOrange.withOpacity(0.8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 18,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGreen.withOpacity(0.8),
                    ),
                  ),
                ),
                Positioned(
                  top: 22,
                  left: 22,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(end: -8, duration: 2.seconds, curve: Curves.easeInOut),
            const SizedBox(height: 32),
            Text(
              'No tasks yet!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the + button to add your\nfirst task and get productive.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
