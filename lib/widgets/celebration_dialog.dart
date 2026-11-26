import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/study_storage_service.dart';
import '../theme/app_theme.dart';

/// 完成今日 3 件小事后触发的治愈系鼓励语录与徽章解锁动画弹窗
Future<void> showDailyCelebrationDialog(BuildContext context) async {
  HapticFeedback.heavyImpact();
  final quote = StudyStorageService.randomHealingQuote();
  await StudyStorageService.markTodayCelebrated();
  if (!context.mounted) return;

  final isDark = Theme.of(context).brightness == Brightness.dark;
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'celebration',
    barrierColor: Colors.black.withOpacity(0.65),
    transitionDuration: const Duration(milliseconds: 340),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.elasticOut);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.78, end: 1.0).animate(curved),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
    pageBuilder: (ctx, _, __) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface(isDark),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.kleinBlue.withOpacity(0.28),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.kleinBlue, Color(0xFF4C7BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.kleinBlue.withOpacity(0.4),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('🏆', style: TextStyle(fontSize: 36)),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.mintGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '✨ 今日 3 件小事全部通关！',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.mintGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '450+ 稳过进度条又涨一格！',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppTheme.pillDecoration(isDark, radius: 16),
                  child: Text(
                    '“$quote”',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary(isDark),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '收下今日勋章，明天继续！',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
