import 'package:flutter/material.dart';
import '../services/app_store.dart';
import '../theme/app_theme.dart';

/// 极简顶栏：仅保留“距离 2027年6月六级考试倒计时”与“今日打卡状态”，不占多余屏幕空间
class MinimalTopBar extends StatelessWidget {
  const MinimalTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final checkedIn = store.isCheckedInToday;
        return Container(
          color: AppColors.surface,
          child: SafeArea(
            bottom: false,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_outlined,
                    size: 17,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '距离2027年6月六级',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${store.daysUntilExam} 天',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _showCheckInDialog(context, store),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: checkedIn
                            ? AppColors.successSoft
                            : AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: checkedIn
                              ? AppColors.success.withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            checkedIn
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 14,
                            color: checkedIn
                                ? AppColors.success
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            checkedIn ? '今日已打卡' : '今日未打卡',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: checkedIn
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                          ),
                        ],
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

  void _showCheckInDialog(BuildContext context, AppStore store) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text(
            '今日学习打卡',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statRow('今日已背单词', '${store.todayStudiedCount} / ${store.dailyGoal} 词'),
              const SizedBox(height: 8),
              _statRow('已掌握核心词', '${store.masteredCount} / ${store.allVocab.length} 词'),
              const SizedBox(height: 8),
              _statRow('生词本收藏', '${store.wordbookIds.length} 词'),
              const SizedBox(height: 8),
              _statRow('累计打卡天数', '${store.totalCheckedInDays} 天'),
              const SizedBox(height: 12),
              Text(
                store.isCheckedInToday
                    ? '今日已完成学习打卡，保持稳定节奏即可稳过六级。'
                    : '每日背满 5 词、完成任意听力/阅读练习或写译练习将自动打卡，也可手动确认打卡。',
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('关闭'),
            ),
            if (!store.isCheckedInToday)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  await store.checkInToday();
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('立即打卡'),
              ),
          ],
        );
      },
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
