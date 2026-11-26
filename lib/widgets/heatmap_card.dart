import 'package:flutter/material.dart';
import '../services/study_storage_service.dart';
import '../theme/app_theme.dart';

/// GitHub 风格 12 周学习打卡热力图 + 连续连击徽章墙
class StudyHeatmapCard extends StatelessWidget {
  final Map<String, int> heatmap;
  final int streakDays;
  final List<StudyBadge> badges;

  const StudyHeatmapCard({
    super.key,
    required this.heatmap,
    required this.streakDays,
    required this.badges,
  });

  Color _cellColor(int score, bool isDark) {
    if (score <= 0) {
      return isDark ? const Color(0xFF222D45) : const Color(0xFFEBE7DE);
    }
    if (score <= 2) return AppTheme.kleinBlue.withOpacity(0.32);
    if (score <= 6) return AppTheme.kleinBlue.withOpacity(0.58);
    if (score <= 14) return AppTheme.kleinBlue.withOpacity(0.82);
    return AppTheme.kleinBlue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    // 展示近 12 周（84 天）按列(周) x 7行(天) 排列，贴近 GitHub 贡献格
    const int weeks = 12;
    const int totalDays = weeks * 7;
    final DateTime startDay = today.subtract(const Duration(days: totalDays - 1));
    final int activeDays = heatmap.values.where((v) => v > 0).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(isDark, radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.primary(isDark).withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_fire_department_rounded,
                  color: AppTheme.primary(isDark),
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '学习打卡热力图与连击徽章',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      '累计点亮 $activeDays 天 · 每背词/精读/精听自动记录',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.warmAmber, Color(0xFFFF7A00)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '🔥 连击 $streakDays 天',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 12周 x 7天 GitHub 热力图格子
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              children: List.generate(weeks, (w) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Column(
                    children: List.generate(7, (d) {
                      final date = startDay.add(Duration(days: w * 7 + d));
                      final key = StudyStorageService.todayKey(date);
                      final score = heatmap[key] ?? 0;
                      final isToday = key == StudyStorageService.todayKey(today);
                      return Tooltip(
                        message: '$key · 学习活跃度 $score',
                        child: Container(
                          width: 17,
                          height: 17,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: _cellColor(score, isDark),
                            borderRadius: BorderRadius.circular(5),
                            border: isToday
                                ? Border.all(
                                    color: AppTheme.warmAmber,
                                    width: 1.6,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),

          // 图例
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('少 ', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary(isDark))),
              ...[0, 2, 5, 12, 20].map(
                (v) => Container(
                  width: 11,
                  height: 11,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _cellColor(v, isDark),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Text(' 多', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary(isDark))),
            ],
          ),
          const SizedBox(height: 14),

          // 连击与通关徽章墙
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: badges.map((b) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: b.unlocked
                      ? AppTheme.primary(isDark).withOpacity(isDark ? 0.2 : 0.1)
                      : AppTheme.subtle(isDark),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Opacity(
                      opacity: b.unlocked ? 1.0 : 0.35,
                      child: Text(b.emoji, style: const TextStyle(fontSize: 14)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      b.title,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: b.unlocked ? FontWeight.w800 : FontWeight.w500,
                        color: b.unlocked
                            ? AppTheme.primary(isDark)
                            : AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
