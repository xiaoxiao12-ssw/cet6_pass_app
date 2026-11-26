import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/study_models.dart';
import '../services/study_storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_dialog.dart';
import '../widgets/heatmap_card.dart';

class DashboardPage extends StatefulWidget {
  final ValueChanged<int> onNavigateTab;

  const DashboardPage({super.key, required this.onNavigateTab});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DailyTaskSnapshot _daily = DailyTaskSnapshot(dateKey: StudyStorageService.todayKey());
  Map<String, int> _heatmap = {};
  List<StudyBadge> _badges = [];
  List<MockScoreRecord> _mockRecords = [];

  // 425压线提分算分器状态
  double _writing = 72.0; // 满分 106.5
  double _translation = 70.0; // 满分 106.5
  double _listenAB = 9.0; // 15题 × 7.1 = 106.5
  double _listenC = 5.0; // 10题 × 14.2 = 142.0
  double _carefulRead = 7.0; // 10题 × 14.2 = 142.0（必争核心！）
  double _matchRead = 8.0; // 10题 × 7.1 = 71.0
  double _bankedCloze = 3.0; // 10题 × 3.55 = 35.5（战略放弃！）

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
    StudyStorageService.version.addListener(_loadAll);
  }

  @override
  void dispose() {
    StudyStorageService.version.removeListener(_loadAll);
    super.dispose();
  }

  Future<void> _loadAll() async {
    final daily = await StudyStorageService.loadDailyTask();
    final heatmap = await StudyStorageService.loadHeatmap();
    final badges = await StudyStorageService.computeBadges();
    final sim = await StudyStorageService.loadScoreSimulator();
    final mocks = await StudyStorageService.loadMockScores();
    if (!mounted) return;
    setState(() {
      _daily = daily;
      _heatmap = heatmap;
      _badges = badges;
      _mockRecords = mocks;
      _writing = (sim['writing'] ?? 72.0).clamp(0, 106.5);
      _translation = (sim['translation'] ?? 70.0).clamp(0, 106.5);
      _listenAB = (sim['listenAB'] ?? 9.0).clamp(0, 15);
      _listenC = (sim['listenC'] ?? 5.0).clamp(0, 10);
      _carefulRead = (sim['carefulRead'] ?? 7.0).clamp(0, 10);
      _matchRead = (sim['matchRead'] ?? 8.0).clamp(0, 10);
      _bankedCloze = (sim['bankedCloze'] ?? 3.0).clamp(0, 10);
      _loading = false;
    });
  }

  double get _listeningScore => _listenAB * 7.1 + _listenC * 14.2;
  double get _readingScore =>
      _carefulRead * 14.2 + _matchRead * 7.1 + _bankedCloze * 3.55;
  double get _totalScore =>
      _writing + _translation + _listeningScore + _readingScore;

  void _saveSim() {
    StudyStorageService.saveScoreSimulator({
      'writing': _writing,
      'translation': _translation,
      'listenAB': _listenAB,
      'listenC': _listenC,
      'carefulRead': _carefulRead,
      'matchRead': _matchRead,
      'bankedCloze': _bankedCloze,
    });
  }

  void _apply460Preset() {
    HapticFeedback.mediumImpact();
    setState(() {
      _writing = 74.0;
      _translation = 72.0;
      _listenAB = 9.0;
      _listenC = 5.0;
      _carefulRead = 7.0;
      _matchRead = 8.0;
      _bankedCloze = 2.0;
    });
    _saveSim();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已填入【425压线稳过460分方案】：猛攻14.2分仔细阅读+作文翻译，选词填空仅蒙2题！'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveCurrentAsMock() async {
    HapticFeedback.mediumImpact();
    final rec = MockScoreRecord(
      dateKey: StudyStorageService.todayKey(),
      totalScore: double.parse(_totalScore.toStringAsFixed(1)),
      writing: _writing,
      translation: _translation,
      listening: double.parse(_listeningScore.toStringAsFixed(1)),
      reading: double.parse(_readingScore.toStringAsFixed(1)),
    );
    await StudyStorageService.addMockScore(rec);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已保存模考成绩：${rec.totalScore.toStringAsFixed(1)} 分'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 根据当前日期自动判定处于三阶段中的哪一期（默认 11月-2月 阶段一）
  int _activeStageIndex(DateTime now) {
    final m = now.month;
    if (m == 3 || m == 4) return 1;
    if (m == 5 || m == 6) return 2;
    return 0; // 11月~2月（及其他筹备期）为阶段一
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final examDate = DateTime(2027, 6, 12);
    final regDate = DateTime(2027, 3, 10);
    final int daysToExam = max(0, examDate.difference(DateTime(now.year, now.month, now.day)).inDays);
    final int daysToReg = max(0, regDate.difference(DateTime(now.year, now.month, now.day)).inDays);
    final int activeStage = _activeStageIndex(now);
    final int streakDays = StudyStorageService.computeStreakDays(_heatmap);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 顶部品牌标题行
                    Padding(
                      padding: const EdgeInsets.only(right: 48, bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.kleinBlue, AppTheme.kleinBlueLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.kleinBlue.withOpacity(0.32),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              '6',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '六级必过通',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.textPrimary(isDark),
                                  ),
                                ),
                                Text(
                                  '425 压线专属 · 冲刺 2027年6月 450+ 稳过',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: AppTheme.textSecondary(isDark),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 1. 倒计时与三阶段备考驾驶舱 Hero 卡
                    _buildCountdownHero(daysToExam, daysToReg, activeStage, isDark),
                    const SizedBox(height: 16),

                    // 2. 今日仅需完成的 3 件小事
                    _buildDailyThreeTasksCard(isDark),
                    const SizedBox(height: 16),

                    // 3. 425分压线专属提分算分器（710分真实权重）
                    _buildScoreSimulatorCard(isDark),
                    const SizedBox(height: 16),

                    // 4. GitHub 风格打卡热力图 + 连击徽章
                    StudyHeatmapCard(
                      heatmap: _heatmap,
                      streakDays: streakDays,
                      badges: _badges,
                    ),

                    // 5. 最近模考分数记录
                    if (_mockRecords.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildMockHistoryCard(isDark),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCountdownHero(
    int daysToExam,
    int daysToReg,
    int activeStage,
    bool isDark,
  ) {
    final stages = [
      ('阶段一', '11月-2月', '高频词+核心语法救命期'),
      ('阶段二', '3月-4月', '阅读+听力专项突破期'),
      ('阶段三', '5月-6月', '真题模考+模板冲刺期'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1538C8), AppTheme.kleinBlue, Color(0xFF3366FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kleinBlue.withOpacity(0.32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🎯 目标：2027年6月12日 450+ 稳过',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warmAmber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '报名提醒 $daysToReg天',
                  style: const TextStyle(
                    color: Color(0xFF1A1400),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 大数字倒计时
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$daysToExam',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.w900,
                  height: 0.95,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '天 · 距预计六级开考',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '预计 2027年3月上旬 开启官网报名，切勿错过',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 三阶段自动高亮路线图
          Row(
            children: List.generate(3, (i) {
              final st = stages[i];
              final isCurrent = i == activeStage;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.white
                        : Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            st.$1,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: isCurrent ? AppTheme.kleinBlue : Colors.white,
                            ),
                          ),
                          const Spacer(),
                          if (isCurrent)
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppTheme.mintGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        st.$2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isCurrent
                              ? AppTheme.kleinBlue.withOpacity(0.75)
                              : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        st.$3,
                        style: TextStyle(
                          fontSize: 10.5,
                          height: 1.25,
                          fontWeight: FontWeight.w700,
                          color: isCurrent
                              ? const Color(0xFF141B2D)
                              : Colors.white.withOpacity(0.92),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyThreeTasksCard(bool isDark) {
    final primary = AppTheme.primary(isDark);
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
                  color: primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.check_circle_rounded, color: primary, size: 18),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '今日仅需完成的 3 件小事',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      '拒绝贪多放弃，每天稳稳搞定这 3 件就足够上岸',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (_daily.allCompleted ? AppTheme.mintGreen : primary)
                      .withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_daily.completedCount} / 3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: _daily.allCompleted ? AppTheme.mintGreen : primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _taskTile(
            isDark: isDark,
            done: _daily.vocabDone,
            emoji: '⚡',
            title: '背 20 个真题高频救命词',
            subtitle: '今日已刷 ${_daily.vocabDoneCount} / 20 词 · 艾宾浩斯智能记忆',
            actionText: _daily.vocabDone ? '继续刷词' : '去背词',
            onTap: () => widget.onNavigateTab(1),
          ),
          const SizedBox(height: 10),
          _taskTile(
            isDark: isDark,
            done: _daily.readingDone,
            emoji: '📖',
            title: '精读 1 篇真题长难句',
            subtitle: '吃透主干修饰拆解，猛抓 14.2分/题 的仔细阅读',
            actionText: _daily.readingDone ? '再读一篇' : '去精读',
            onTap: () => widget.onNavigateTab(2),
          ),
          const SizedBox(height: 10),
          _taskTile(
            isDark: isDark,
            done: _daily.listeningDone,
            emoji: '🎧',
            title: '盲听 + 精听 1 段听力短文',
            subtitle: '抓同义替换词，练就考场防坑听感',
            actionText: _daily.listeningDone ? '继续磨耳' : '去磨耳',
            onTap: () => widget.onNavigateTab(3),
          ),

          if (_daily.allCompleted) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => showDailyCelebrationDialog(context),
                icon: const Icon(Icons.emoji_events_rounded, size: 18),
                label: const Text(
                  '🎉 今日全部通关！点击领取治愈鼓励与勋章',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mintGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _taskTile({
    required bool isDark,
    required bool done,
    required String emoji,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    final primary = AppTheme.primary(isDark);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          decoration: AppTheme.pillDecoration(
            isDark,
            radius: 16,
            color: done
                ? AppTheme.mintGreen.withOpacity(isDark ? 0.16 : 0.10)
                : AppTheme.subtle(isDark),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: done
                      ? AppTheme.mintGreen
                      : AppTheme.surface(isDark),
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: done
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                    : Text(emoji, style: const TextStyle(fontSize: 17)),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: done ? AppTheme.mintGreen : primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreSimulatorCard(bool isDark) {
    final total = _totalScore;
    final bool pass450 = total >= 450.0;
    final bool pass425 = total >= 425.0;
    final Color statusColor = pass450
        ? AppTheme.mintGreen
        : (pass425 ? AppTheme.warmAmber : AppTheme.coralRed);

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
                child: Icon(Icons.tune_rounded, color: AppTheme.primary(isDark), size: 18),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '425分压线专属 · 710提分算分器',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      '拖动滑块实时演练怎么凑够 450+ 稳过线',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 保分战略醒目标签
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _strategyPill('🔥 必攻：仔细阅读 14.2分/题', AppTheme.kleinBlue, isDark),
              _strategyPill('✅ 保底：作文+翻译 213分', AppTheme.mintGreen, isDark),
              _strategyPill('⚡ 战略放弃：选词填空 3.55分/题', AppTheme.coralRed, isDark),
            ],
          ),
          const SizedBox(height: 14),

          // 总分实时仪表盘
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.pillDecoration(isDark, radius: 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '预估六级总分',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppTheme.textSecondary(isDark),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              total.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: statusColor,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '/ 710',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSecondary(isDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        pass450
                            ? '🏆 稳过 450+ 线！'
                            : (pass425 ? '⚠️ 425 压线危险' : '🚨 距 450 差 ${(450 - total).toStringAsFixed(0)} 分'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (total / 710.0).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 各题型真实分值权重滑块
          _scoreSlider(
            label: '仔细阅读（10题 × 14.2分）',
            badge: '核心提分区',
            badgeColor: AppTheme.kleinBlue,
            valueLabel: '对 ${_carefulRead.round()} 题 = ${(_carefulRead * 14.2).toStringAsFixed(1)}分',
            value: _carefulRead,
            max: 10,
            divisions: 10,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _carefulRead = v);
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '写作（满分 106.5分）',
            badge: '模板保底',
            badgeColor: AppTheme.mintGreen,
            valueLabel: '${_writing.toStringAsFixed(0)} 分',
            value: _writing,
            max: 106.5,
            divisions: 35,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _writing = v.roundToDouble().clamp(0, 106.5));
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '翻译（满分 106.5分）',
            badge: '平替保底',
            badgeColor: AppTheme.mintGreen,
            valueLabel: '${_translation.toStringAsFixed(0)} 分',
            value: _translation,
            max: 106.5,
            divisions: 35,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _translation = v.roundToDouble().clamp(0, 106.5));
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '听力 Section A+B（15题 × 7.1分）',
            badge: '同义替换',
            badgeColor: AppTheme.violetAccent,
            valueLabel: '对 ${_listenAB.round()} 题 = ${(_listenAB * 7.1).toStringAsFixed(1)}分',
            value: _listenAB,
            max: 15,
            divisions: 15,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _listenAB = v);
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '听力 Section C 讲座（10题 × 14.2分）',
            badge: '高分重灾区',
            badgeColor: AppTheme.warmAmber,
            valueLabel: '对 ${_listenC.round()} 题 = ${(_listenC * 14.2).toStringAsFixed(1)}分',
            value: _listenC,
            max: 10,
            divisions: 10,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _listenC = v);
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '长篇信息匹配（10题 × 7.1分）',
            badge: '送分题',
            badgeColor: AppTheme.mintGreen,
            valueLabel: '对 ${_matchRead.round()} 题 = ${(_matchRead * 7.1).toStringAsFixed(1)}分',
            value: _matchRead,
            max: 10,
            divisions: 10,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _matchRead = v);
              _saveSim();
            },
          ),
          _scoreSlider(
            label: '选词填空（10题 × 3.55分）',
            badge: '战略放弃',
            badgeColor: AppTheme.coralRed,
            valueLabel: '蒙对 ${_bankedCloze.round()} 题 = ${(_bankedCloze * 3.55).toStringAsFixed(1)}分',
            value: _bankedCloze,
            max: 10,
            divisions: 10,
            isDark: isDark,
            onChanged: (v) {
              setState(() => _bankedCloze = v);
              _saveSim();
            },
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _apply460Preset,
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                  label: const Text('一键套用460方案', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary(isDark),
                    side: BorderSide(color: AppTheme.primary(isDark).withOpacity(0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveCurrentAsMock,
                  icon: const Icon(Icons.save_rounded, size: 16),
                  label: const Text('记为模考分数', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary(isDark),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _strategyPill(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }

  Widget _scoreSlider({
    required String label,
    required String badge,
    required Color badgeColor,
    required String valueLabel,
    required double value,
    required double max,
    required int divisions,
    required bool isDark,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary(isDark),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  color: badgeColor,
                ),
              ),
            ),
            const Spacer(),
            Text(
              valueLabel,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: badgeColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: value.clamp(0, max),
            min: 0,
            max: max,
            divisions: divisions,
            activeColor: badgeColor,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildMockHistoryCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration(isDark, radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 历史模考分数档案（最近 ${_mockRecords.length} 次）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 10),
          ..._mockRecords.take(4).map((m) {
            final pass = m.totalScore >= 450;
            return Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: AppTheme.pillDecoration(isDark, radius: 12),
              child: Row(
                children: [
                  Text(
                    m.dateKey,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textSecondary(isDark),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '听${m.listening.round()} · 读${m.reading.round()} · 写译${(m.writing + m.translation).round()}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                  ),
                  Text(
                    '${m.totalScore.toStringAsFixed(1)}分',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: pass ? AppTheme.mintGreen : AppTheme.warmAmber,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
