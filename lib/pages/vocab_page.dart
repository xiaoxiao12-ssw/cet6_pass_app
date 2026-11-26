import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cet6_vocab_data.dart';
import '../models/study_models.dart';
import '../services/study_storage_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_dialog.dart';

class VocabPage extends StatefulWidget {
  const VocabPage({super.key});

  @override
  State<VocabPage> createState() => _VocabPageState();
}

class _VocabPageState extends State<VocabPage> {
  Map<String, EbbinghausProgress> _progressMap = {};
  List<SavedWordEntry> _savedWords = [];
  List<VocabWord> _studyQueue = [];
  DailyTaskSnapshot _daily = DailyTaskSnapshot(dateKey: StudyStorageService.todayKey());

  bool _showWordbook = false;
  bool _showAnswerDetails = false;
  double _dragDx = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    StudyStorageService.version.addListener(_refreshMetadata);
  }

  @override
  void dispose() {
    StudyStorageService.version.removeListener(_refreshMetadata);
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _refreshMetadata() async {
    final progress = await StudyStorageService.loadVocabProgress();
    final saved = await StudyStorageService.loadSavedWords();
    final daily = await StudyStorageService.loadDailyTask();
    if (!mounted) return;
    setState(() {
      _progressMap = progress;
      _savedWords = saved;
      _daily = daily;
    });
  }

  Future<void> _loadData() async {
    final progress = await StudyStorageService.loadVocabProgress();
    final saved = await StudyStorageService.loadSavedWords();
    final daily = await StudyStorageService.loadDailyTask();
    if (!mounted) return;
    setState(() {
      _progressMap = progress;
      _savedWords = saved;
      _daily = daily;
      _studyQueue = _buildSmartQueue(progress);
      _loading = false;
    });
  }

  /// 按艾宾浩斯遗忘曲线构建智能队列：到期复习词 & 错词优先 -> 按考频最高的新词
  List<VocabWord> _buildSmartQueue(Map<String, EbbinghausProgress> map) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final dueOrWrong = <VocabWord>[];
    final fresh = <VocabWord>[];
    final later = <VocabWord>[];

    for (final w in cet6HighFreqVocab) {
      final p = map[w.id];
      if (p == null) {
        fresh.add(w);
      } else if (p.stage == 0 || p.nextReviewMs <= now) {
        dueOrWrong.add(w);
      } else {
        later.add(w);
      }
    }
    return [...dueOrWrong, ...fresh, ...later];
  }

  Future<void> _handleSwipe({required bool known}) async {
    if (_studyQueue.isEmpty) return;
    HapticFeedback.mediumImpact();
    final current = _studyQueue.first;
    final shouldCelebrate = await StudyStorageService.recordWordSwipe(
      current,
      known: known,
    );

    if (!mounted) return;
    setState(() {
      _dragDx = 0;
      _showAnswerDetails = false;
      _studyQueue.removeAt(0);
      if (!known) {
        // 不认识：立刻插入 3 张卡片后重学，强化即时记忆！
        final insertAt = min(3, _studyQueue.length);
        _studyQueue.insert(insertAt, current);
      } else {
        // 秒杀：移到队列末尾
        _studyQueue.add(current);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          known
              ? '✅ 已秒杀「${current.word}」，进入艾宾浩斯遗忘曲线复习队列！'
              : '🔁 已将「${current.word}」加入今日重学队列 & 生词本',
        ),
        duration: const Duration(milliseconds: 1200),
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (shouldCelebrate && mounted) {
      await showDailyCelebrationDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppTheme.primary(isDark);
    final masteredCount = _progressMap.values.where((v) => v.stage >= 1).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('高频救命词 · 艾宾浩斯'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 52),
            child: TextButton.icon(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _showWordbook = !_showWordbook);
              },
              icon: Icon(
                _showWordbook ? Icons.style_rounded : Icons.bookmarks_rounded,
                size: 17,
                color: primary,
              ),
              label: Text(
                _showWordbook ? '去刷词' : '生词本(${_savedWords.length})',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _showWordbook
              ? _buildWordbookView(isDark)
              : _buildCardDeckView(isDark, masteredCount),
    );
  }

  Widget _buildCardDeckView(bool isDark, int masteredCount) {
    final primary = AppTheme.primary(isDark);
    final word = _studyQueue.isNotEmpty ? _studyQueue.first : cet6HighFreqVocab.first;
    final prog = _progressMap[word.id];
    final stage = prog?.stage ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
      child: Column(
        children: [
          // 顶部进度状态条
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: AppTheme.cardDecoration(isDark, radius: 18),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '今日目标：${_daily.vocabDoneCount} / 20 词',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (_daily.vocabDoneCount / 20.0).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: AppTheme.subtle(isDark),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _daily.vocabDone ? AppTheme.mintGreen : primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$masteredCount / ${cet6HighFreqVocab.length}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                    Text(
                      '核心词已解锁',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 可左右滑动的艾宾浩斯高频记忆卡片
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() => _dragDx += details.delta.dx);
              },
              onHorizontalDragEnd: (details) {
                if (_dragDx > 90) {
                  _handleSwipe(known: true);
                } else if (_dragDx < -90) {
                  _handleSwipe(known: false);
                } else {
                  setState(() => _dragDx = 0);
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: _dragDx == 0 ? 220 : 0),
                curve: Curves.easeOutBack,
                transform: Matrix4.identity()
                  ..translate(_dragDx, 0.0)
                  ..rotateZ((_dragDx / 900).clamp(-0.18, 0.18)),
                transformAlignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: AppTheme.cardDecoration(isDark, radius: 28),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 顶部考频标签 + 艾宾浩斯阶段
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.coralRed.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '🔥 真题考过 ${word.frequency} 次',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.coralRed,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    word.tag,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: primary,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  stage == 0 ? '新词/重学' : '曲线 Lv.$stage',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: stage > 0
                                        ? AppTheme.mintGreen
                                        : AppTheme.textSecondary(isDark),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // 英文主词 + 音标 + 本地 TTS 语音发音按钮
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    word.word,
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      color: AppTheme.textPrimary(isDark),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      TtsService.instance.speak(word.word, speed: 1.0);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: primary.withOpacity(isDark ? 0.2 : 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.volume_up_rounded,
                                              size: 18, color: primary),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${word.phonetic}  点我发音',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // 点击展开/默认展示释义切换（方便自测）
                            if (!_showAnswerDetails)
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    setState(() => _showAnswerDetails = true);
                                  },
                                  icon: Icon(Icons.visibility_rounded,
                                      size: 18, color: primary),
                                  label: Text(
                                    '先回忆 2 秒，点我看真题考义 & 助记口诀',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              )
                            else ...[
                              // 真题考义（只列最高频 1~2 个）
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: AppTheme.pillDecoration(
                                  isDark,
                                  radius: 16,
                                  color: primary.withOpacity(isDark ? 0.16 : 0.08),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '🎯 真题高频考义',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: primary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      word.coreMeaning,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.textPrimary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 词根词缀助记口诀
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(13),
                                decoration: AppTheme.pillDecoration(
                                  isDark,
                                  radius: 16,
                                  color: AppTheme.warmAmber.withOpacity(isDark ? 0.16 : 0.11),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '💡 词根词缀助记口诀',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.warmAmber,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      word.mnemonic,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        height: 1.4,
                                        color: AppTheme.textPrimary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 真题原句 + 大白话翻译 + 整句朗读
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: AppTheme.pillDecoration(isDark, radius: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '📝 真题例句与大白话',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.textSecondary(isDark),
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () => TtsService.instance
                                              .speak(word.exampleEn, speed: 0.95),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.play_circle_fill_rounded,
                                                  size: 16, color: primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                '读例句',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w800,
                                                  color: primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      word.exampleEn,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        height: 1.45,
                                        color: AppTheme.textPrimary(isDark),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      word.exampleZh,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        height: 1.4,
                                        color: AppTheme.textSecondary(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // 左滑 / 右滑动态印章提示
                    if (_dragDx.abs() > 24)
                      Positioned(
                        top: 24,
                        left: _dragDx > 0 ? 24 : null,
                        right: _dragDx < 0 ? 24 : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: (_dragDx > 0
                                    ? AppTheme.mintGreen
                                    : AppTheme.coralRed)
                                .withOpacity(0.92),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            _dragDx > 0 ? '✅ 秒杀·进遗忘曲线' : '🔁 不认识·今日重学',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 底部快捷划卡操作栏（支持滑动也支持一键点击）
          Text(
            '← 左滑：不认识（今日重学）    右滑：秒杀（艾宾浩斯） →',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary(isDark),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleSwipe(known: false),
                  icon: const Icon(Icons.close_rounded, size: 20),
                  label: const Text('不认识', style: TextStyle(fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.coralRed.withOpacity(isDark ? 0.22 : 0.12),
                    foregroundColor: AppTheme.coralRed,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: AppTheme.surface(isDark),
                shape: const CircleBorder(),
                elevation: 2,
                child: IconButton(
                  tooltip: '发音朗读',
                  icon: Icon(Icons.volume_up_rounded, color: primary, size: 24),
                  padding: const EdgeInsets.all(14),
                  onPressed: () => TtsService.instance.speak(word.word, speed: 1.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleSwipe(known: true),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: const Text('秒杀记住', style: TextStyle(fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mintGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordbookView(bool isDark) {
    final primary = AppTheme.primary(isDark);
    if (_savedWords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: AppTheme.cardDecoration(isDark, radius: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📘', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 12),
                Text(
                  '生词本 / 错题本还是空的',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '背词左滑“不认识”或在精读页点击陌生词，都会自动收纳到这里反复攻克！',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      itemCount: _savedWords.length,
      itemBuilder: (ctx, i) {
        final item = _savedWords[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: AppTheme.cardDecoration(isDark, radius: 18),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            title: Row(
              children: [
                Text(
                  item.word,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.phonetic,
                  style: TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.warmAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.source,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.warmAmber,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                item.meaning,
                style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary(isDark)),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up_rounded, color: primary, size: 20),
                  onPressed: () => TtsService.instance.speak(item.word, speed: 1.0),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      color: AppTheme.mintGreen, size: 20),
                  tooltip: '已掌握移出',
                  onPressed: () => StudyStorageService.removeSavedWord(item.word),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
