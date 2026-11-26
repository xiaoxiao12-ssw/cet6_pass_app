import 'dart:async';
import 'package:flutter/material.dart';
import '../data/cet6_reading_data.dart';
import '../models/cet6_models.dart';
import '../services/app_store.dart';
import '../theme/app_theme.dart';
import '../widgets/clickable_reading_text.dart';

/// Tab 3：阅读（完整覆盖六级阅读三大题型）
/// ① 选词填空 (Banked Cloze, 15选10, 3.55分/题)
/// ② 长篇阅读匹配 (Matching, 段落信息匹配, 7.1分/题)
/// ③ 仔细阅读 (Careful Reading, 深度单选, 14.2分/题)
/// 支持计时做题、交卷按六级权重自动折算得分、逐句双语对照解析、点击核心生词查词并一键加入 Tab 1 生词本
class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  ReadingSectionType _section = ReadingSectionType.bankedCloze;
  int _exerciseIndex = 0;

  // 双模式：false = 计时做题模式, true = 逐句双语解析模式
  bool _analysisMode = false;

  // 计时器状态
  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _timerRunning = true;

  // 当前作答缓存（key: 题号字符串 '1'..'10', value: 选项字母或数字索引字符串）
  final Map<String, String> _answers = {};
  bool _submitted = false;

  // 长篇阅读子视图切换：0 = 原文 [A-H], 1 = 10道匹配题
  int _matchingSubView = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentExercise();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _currentExerciseId {
    switch (_section) {
      case ReadingSectionType.bankedCloze:
        return cet6BankedClozeExercises[_exerciseIndex].id;
      case ReadingSectionType.matching:
        return cet6MatchingExercises[_exerciseIndex].id;
      case ReadingSectionType.carefulReading:
        return cet6CarefulReadingExercises[_exerciseIndex].id;
    }
  }

  int get _exerciseCount {
    switch (_section) {
      case ReadingSectionType.bankedCloze:
        return cet6BankedClozeExercises.length;
      case ReadingSectionType.matching:
        return cet6MatchingExercises.length;
      case ReadingSectionType.carefulReading:
        return cet6CarefulReadingExercises.length;
    }
  }

  String _exerciseShortTitle(int idx) {
    switch (_section) {
      case ReadingSectionType.bankedCloze:
        return '第 ${idx + 1} 篇';
      case ReadingSectionType.matching:
        return '真题模拟 ${idx + 1}';
      case ReadingSectionType.carefulReading:
        return 'Passage ${idx + 1}';
    }
  }

  String _exerciseIdAt(int idx) {
    switch (_section) {
      case ReadingSectionType.bankedCloze:
        return cet6BankedClozeExercises[idx].id;
      case ReadingSectionType.matching:
        return cet6MatchingExercises[idx].id;
      case ReadingSectionType.carefulReading:
        return cet6CarefulReadingExercises[idx].id;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_timerRunning || _submitted) return;
      setState(() => _elapsedSeconds++);
    });
  }

  void _loadCurrentExercise() {
    _timer?.cancel();
    final saved = AppStore.instance.getReadingRecord(_currentExerciseId);
    _answers.clear();
    _matchingSubView = 0;
    if (saved != null) {
      _answers.addAll(saved.userAnswers);
      _elapsedSeconds = saved.elapsedSeconds;
      _submitted = true;
      _timerRunning = false;
      _analysisMode = false;
    } else {
      _elapsedSeconds = 0;
      _submitted = false;
      _analysisMode = false;
      _startTimer();
    }
  }

  void _selectSection(ReadingSectionType type) {
    if (_section == type) return;
    setState(() {
      _section = type;
      _exerciseIndex = 0;
      _loadCurrentExercise();
    });
  }

  void _selectExercise(int idx) {
    if (_exerciseIndex == idx) return;
    setState(() {
      _exerciseIndex = idx;
      _loadCurrentExercise();
    });
  }

  void _resetCurrent() {
    setState(() {
      _answers.clear();
      _elapsedSeconds = 0;
      _submitted = false;
      _analysisMode = false;
      _startTimer();
    });
  }

  String _formatDuration(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  Future<void> _submitCurrent() async {
    int total = 0;
    int correct = 0;
    final wrongNums = <int>[];

    switch (_section) {
      case ReadingSectionType.bankedCloze:
        final ex = cet6BankedClozeExercises[_exerciseIndex];
        total = ex.answers.length;
        if (_answers.length < total) {
          _showIncompleteHint(total - _answers.length);
          return;
        }
        for (int i = 0; i < total; i++) {
          final numKey = '${i + 1}';
          if (_answers[numKey] == ex.answers[i]) {
            correct++;
          } else {
            wrongNums.add(i + 1);
          }
        }
        break;
      case ReadingSectionType.matching:
        final ex = cet6MatchingExercises[_exerciseIndex];
        total = ex.statements.length;
        if (_answers.length < total) {
          _showIncompleteHint(total - _answers.length);
          return;
        }
        for (final st in ex.statements) {
          if (_answers['${st.number}'] == st.answerLabel) {
            correct++;
          } else {
            wrongNums.add(st.number);
          }
        }
        break;
      case ReadingSectionType.carefulReading:
        final ex = cet6CarefulReadingExercises[_exerciseIndex];
        total = ex.questions.length;
        if (_answers.length < total) {
          _showIncompleteHint(total - _answers.length);
          return;
        }
        for (final q in ex.questions) {
          if (_answers['${q.number}'] == '${q.answerIndex}') {
            correct++;
          } else {
            wrongNums.add(q.number);
          }
        }
        break;
    }

    _timer?.cancel();
    final perQ = _section.scorePerQuestion;
    final cet6Score = double.parse((correct * perQ).toStringAsFixed(1));
    final maxScore = double.parse((total * perQ).toStringAsFixed(1));

    final record = ReadingRecord(
      correctCount: correct,
      totalCount: total,
      cet6Score: cet6Score,
      maxCet6Score: maxScore,
      elapsedSeconds: _elapsedSeconds,
      userAnswers: Map<String, String>.from(_answers),
      wrongNumbers: wrongNums,
      submittedAt: AppStore.todayKey,
    );

    await AppStore.instance.saveReadingRecord(_currentExerciseId, record);
    if (!mounted) return;
    setState(() {
      _submitted = true;
      _timerRunning = false;
    });
  }

  void _showIncompleteHint(int remaining) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('还有 $remaining 题未作答，请全部完成后交卷算分'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedRecord = AppStore.instance.getReadingRecord(_currentExerciseId);

    return Column(
      children: [
        // 1. 三大真实阅读题型切换栏
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            children: [
              Row(
                children: ReadingSectionType.values.map((type) {
                  final selected = _section == type;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: type == ReadingSectionType.carefulReading ? 0 : 8,
                      ),
                      child: InkWell(
                        onTap: () => _selectSection(type),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.surfaceSubtle,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            type.shortLabel,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // 篇目选择 + 计时/分数 + 模式切换
              Row(
                children: [
                  ...List.generate(_exerciseCount, (i) {
                    final active = i == _exerciseIndex;
                    final rec = AppStore.instance.getReadingRecord(_exerciseIdAt(i));
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () => _selectExercise(i),
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySoft
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color:
                                  active ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            rec != null
                                ? '${_exerciseShortTitle(i)} · ${rec.cet6Score}分'
                                : _exerciseShortTitle(i),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  // 计时器显示与暂停
                  InkWell(
                    onTap: _submitted
                        ? null
                        : () => setState(() => _timerRunning = !_timerRunning),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _submitted
                                ? Icons.timer_outlined
                                : (_timerRunning
                                    ? Icons.pause_circle_outline_rounded
                                    : Icons.play_circle_outline_rounded),
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(_elapsedSeconds),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. 做题 / 逐句双语解析 双模式切换条 + 折算得分展示
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          child: Row(
            children: [
              _modeButton('做题模式', !_analysisMode, () {
                setState(() => _analysisMode = false);
              }),
              const SizedBox(width: 8),
              _modeButton('逐句双语解析', _analysisMode, () {
                setState(() => _analysisMode = true);
              }),
              const Spacer(),
              if (_submitted && savedRecord != null) ...[
                Text(
                  '${savedRecord.cet6Score}/${savedRecord.maxCet6Score}分',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _resetCurrent,
                  child: const Text(
                    '重做',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ] else
                Text(
                  _section.weightBadge,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 点词查词轻提示条
        Container(
          width: double.infinity,
          color: AppColors.primarySoft.withValues(alpha: 0.65),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: const Text(
            '点击文章中带虚线的六级核心生词，可直接弹窗查词并一键加入 Tab 1 生词本',
            style: TextStyle(fontSize: 11.5, color: AppColors.primary),
          ),
        ),

        // 3. 题型内容区
        Expanded(
          child: _buildSectionBody(savedRecord),
        ),
      ],
    );
  }

  Widget _modeButton(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionBody(ReadingRecord? savedRecord) {
    switch (_section) {
      case ReadingSectionType.bankedCloze:
        final ex = cet6BankedClozeExercises[_exerciseIndex];
        return _analysisMode
            ? _buildBankedClozeAnalysis(ex)
            : _buildBankedClozePractice(ex, savedRecord);
      case ReadingSectionType.matching:
        final ex = cet6MatchingExercises[_exerciseIndex];
        return _analysisMode
            ? _buildMatchingAnalysis(ex)
            : _buildMatchingPractice(ex, savedRecord);
      case ReadingSectionType.carefulReading:
        final ex = cet6CarefulReadingExercises[_exerciseIndex];
        return _analysisMode
            ? _buildCarefulAnalysis(ex)
            : _buildCarefulPractice(ex, savedRecord);
    }
  }

  Widget _buildScoreBanner(ReadingRecord rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '六级权重折算得分：${rec.cet6Score} / ${rec.maxCet6Score} 分',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '答对 ${rec.correctCount} / ${rec.totalCount} 题 · 用时 ${_formatDuration(rec.elapsedSeconds)}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => setState(() => _analysisMode = true),
            child: const Text('双语解析', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // ==================== ① 选词填空 (15选10) ====================

  Widget _buildBankedClozePractice(
    BankedClozeExercise ex,
    ReadingRecord? savedRecord,
  ) {
    final optionByLetter = {for (final o in ex.wordBank) o.letter: o};
    final paragraphs = ex.rawPassage.split('\n\n');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        if (_submitted && savedRecord != null) _buildScoreBanner(savedRecord),
        _headerCard(ex.title, ex.subtitle),
        const SizedBox(height: 12),

        // 含可点击空位 [1]..[10] 的文章卡片
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '点击文中编号空位从 15 词库中选词填入：',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              ...paragraphs.map((para) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildClozeParagraph(para, ex, optionByLetter),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 15 词备选词库总览卡片
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '15 选 10 备选词库（A–O）',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ex.wordBank.map((opt) {
                  final used = _answers.values.contains(opt.letter);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: used
                          ? AppColors.primarySoft
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: used ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '${opt.letter}) ${opt.word}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: used ? FontWeight.w700 : FontWeight.w500,
                        decoration: used ? TextDecoration.lineThrough : null,
                        color: used
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        if (!_submitted)
          _submitButton('交卷算分（按六级 3.55 分/题折算）')
        else
          _buildClozeExplanationsCard(ex),
      ],
    );
  }

  Widget _buildClozeParagraph(
    String paragraph,
    BankedClozeExercise ex,
    Map<String, BankedClozeOption> optionByLetter,
  ) {
    final regex = RegExp(r'\{\{(\d+)\}\}');
    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in regex.allMatches(paragraph)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: paragraph.substring(lastEnd, match.start),
            style: const TextStyle(
              fontSize: 14.8,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }

      final numStr = match.group(1)!;
      final blankIndex = int.parse(numStr) - 1;
      final selectedLetter = _answers[numStr];
      final selectedWord = selectedLetter != null
          ? optionByLetter[selectedLetter]?.word ?? selectedLetter
          : null;
      final correctLetter = ex.answers[blankIndex];
      final isCorrect = selectedLetter == correctLetter;

      Color bg = AppColors.primarySoft;
      Color border = AppColors.primary.withValues(alpha: 0.4);
      Color fg = AppColors.primary;

      if (_submitted) {
        if (isCorrect) {
          bg = AppColors.successSoft;
          border = AppColors.success;
          fg = AppColors.success;
        } else {
          bg = AppColors.dangerSoft;
          border = AppColors.danger;
          fg = AppColors.danger;
        }
      } else if (selectedLetter != null) {
        bg = AppColors.primary;
        border = AppColors.primary;
        fg = Colors.white;
      }

      final label = selectedWord != null
          ? _submitted && !isCorrect
              ? '($numStr) $selectedLetter→$correctLetter'
              : '($numStr) $selectedLetter.$selectedWord'
          : '  ($numStr) 请选词  ';

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: _submitted
                ? null
                : () => _openBankedClozePicker(ex, numStr),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: border),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ),
          ),
        ),
      );
      lastEnd = match.end;
    }

    if (lastEnd < paragraph.length) {
      spans.add(
        TextSpan(
          text: paragraph.substring(lastEnd),
          style: const TextStyle(
            fontSize: 14.8,
            height: 1.8,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }

    return Text.rich(TextSpan(children: spans));
  }

  void _openBankedClozePicker(BankedClozeExercise ex, String blankNum) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '为第 ($blankNum) 空选择单词',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    if (_answers.containsKey(blankNum))
                      TextButton(
                        onPressed: () {
                          setState(() => _answers.remove(blankNum));
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('清空本空'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ex.wordBank.map((opt) {
                    final isCurrent = _answers[blankNum] == opt.letter;
                    final usedElsewhere = _answers.entries.any(
                      (e) => e.key != blankNum && e.value == opt.letter,
                    );
                    return InkWell(
                      onTap: () {
                        setState(() => _answers[blankNum] = opt.letter);
                        Navigator.of(ctx).pop();
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppColors.primary
                              : (usedElsewhere
                                  ? AppColors.surfaceSubtle
                                  : AppColors.background),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          '${opt.letter}) ${opt.word}${usedElsewhere ? " (已用)" : ""}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isCurrent
                                ? Colors.white
                                : (usedElsewhere
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClozeExplanationsCard(BankedClozeExercise ex) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '逐题答案与词性逻辑解析',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          ...ex.explanations.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Text(
                e,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankedClozeAnalysis(BankedClozeExercise ex) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _headerCard(ex.title, '逐句双语精读 · 点击下划线六级词可直接查词加入生词本'),
        const SizedBox(height: 12),
        ...ex.bilingualSentences.map(_bilingualSentenceCard),
        const SizedBox(height: 8),
        _buildClozeExplanationsCard(ex),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '15 备选词词性与释义速览',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              ...ex.wordBank.map(
                (o) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    '${o.letter}) ${o.word}  —  ${o.posHint}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== ② 长篇阅读匹配 (段落信息匹配) ====================

  Widget _buildMatchingPractice(
    MatchingExercise ex,
    ReadingRecord? savedRecord,
  ) {
    final labels = ex.paragraphs.map((p) => p.label).toList();

    return Column(
      children: [
        Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              Expanded(
                child: _subSwitchChip(
                  '查看长文原文 [${labels.first}–${labels.last}]',
                  _matchingSubView == 0,
                  () => setState(() => _matchingSubView = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _subSwitchChip(
                  '10 道段落匹配题 (${_answers.length}/${ex.statements.length})',
                  _matchingSubView == 1,
                  () => setState(() => _matchingSubView = 1),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (_submitted && savedRecord != null)
                _buildScoreBanner(savedRecord),
              _headerCard(ex.title, ex.subtitle),
              const SizedBox(height: 12),
              if (_matchingSubView == 0) ...[
                ...ex.paragraphs.map(
                  (p) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Paragraph ${p.label}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClickableReadingText(text: p.fullEn),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () => setState(() => _matchingSubView = 1),
                    child: const Text('前往 10 道匹配题作答'),
                  ),
                ),
              ] else ...[
                ...ex.statements.map((st) {
                  final picked = _answers['${st.number}'];
                  final isCorrect = picked == st.answerLabel;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _submitted
                            ? (isCorrect
                                ? AppColors.success
                                : AppColors.danger)
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${st.number}. ${st.statement}',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: labels.map((lbl) {
                            final selected = picked == lbl;
                            final correctOpt = st.answerLabel == lbl;

                            Color bg = AppColors.background;
                            Color border = AppColors.border;
                            Color fg = AppColors.textSecondary;

                            if (_submitted) {
                              if (correctOpt) {
                                bg = AppColors.successSoft;
                                border = AppColors.success;
                                fg = AppColors.success;
                              } else if (selected && !correctOpt) {
                                bg = AppColors.dangerSoft;
                                border = AppColors.danger;
                                fg = AppColors.danger;
                              }
                            } else if (selected) {
                              bg = AppColors.primary;
                              border = AppColors.primary;
                              fg = Colors.white;
                            }

                            return InkWell(
                              onTap: _submitted
                                  ? null
                                  : () => setState(
                                      () => _answers['${st.number}'] = lbl),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                width: 34,
                                height: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: border),
                                ),
                                child: Text(
                                  lbl,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: fg,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_submitted) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '答案：[${st.answerLabel}]  定位词：${st.keyPhrase}\n${st.explanation}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                height: 1.45,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
                if (!_submitted) _submitButton('交卷算分（按六级 7.1 分/题折算）'),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchingAnalysis(MatchingExercise ex) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _headerCard(ex.title, '全段落逐句双语精读 · 点击下划线核心词可查词并加入生词本'),
        const SizedBox(height: 12),
        ...ex.paragraphs.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paragraph ${p.label}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ...p.sentences.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClickableReadingText(
                          text: s.en,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.zh,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: AppColors.textSecondary,
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
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '10 题段落定位速查表',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              ...ex.statements.map(
                (st) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Q${st.number} → [${st.answerLabel}]  ${st.explanation}',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== ③ 仔细阅读 (深度单选) ====================

  Widget _buildCarefulPractice(
    CarefulReadingExercise ex,
    ReadingRecord? savedRecord,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        if (_submitted && savedRecord != null) _buildScoreBanner(savedRecord),
        _headerCard(ex.title, ex.subtitle),
        const SizedBox(height: 12),

        // 英文阅读全文卡片（支持点词查词）
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(ex.paragraphs.length, (pIdx) {
              final paraText = ex.paragraphs[pIdx].map((s) => s.en).join(' ');
              return Padding(
                padding: EdgeInsets.only(
                  bottom: pIdx == ex.paragraphs.length - 1 ? 0 : 12,
                ),
                child: ClickableReadingText(text: paraText),
              );
            }),
          ),
        ),
        const SizedBox(height: 14),

        // 5 道深度单选题
        ...ex.questions.map((q) {
          final picked = int.tryParse(_answers['${q.number}'] ?? '');
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${q.number}. ${q.question}',
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(q.options.length, (optIdx) {
                  final selected = picked == optIdx;
                  final isCorrect = q.answerIndex == optIdx;

                  Color bg = AppColors.background;
                  Color border = AppColors.border;
                  Color fg = AppColors.textPrimary;

                  if (_submitted) {
                    if (isCorrect) {
                      bg = AppColors.successSoft;
                      border = AppColors.success;
                      fg = AppColors.success;
                    } else if (selected && !isCorrect) {
                      bg = AppColors.dangerSoft;
                      border = AppColors.danger;
                      fg = AppColors.danger;
                    }
                  } else if (selected) {
                    bg = AppColors.primarySoft;
                    border = AppColors.primary;
                    fg = AppColors.primary;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: InkWell(
                      onTap: _submitted
                          ? null
                          : () => setState(
                              () => _answers['${q.number}'] = '$optIdx'),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: border),
                        ),
                        child: Text(
                          q.options[optIdx],
                          style: TextStyle(
                            fontSize: 13.5,
                            height: 1.4,
                            fontWeight: (selected || (_submitted && isCorrect))
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: fg,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (_submitted) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${q.locateHint} · ${q.explanation}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 6),
        if (!_submitted) _submitButton('交卷算分（按六级 14.2 分/题折算）'),
      ],
    );
  }

  Widget _buildCarefulAnalysis(CarefulReadingExercise ex) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        _headerCard(ex.title, '逐句双语对照精读 · 点击下划线六级词可弹窗查词并加入生词本'),
        const SizedBox(height: 12),
        ...List.generate(ex.paragraphs.length, (pIdx) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '第 ${pIdx + 1} 段',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ...ex.paragraphs[pIdx].map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClickableReadingText(
                          text: s.en,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.zh,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '全部题目定位与解析',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              ...ex.questions.map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    'Q${q.number}（${q.options[q.answerIndex].substring(0, 1)}）· ${q.locateHint}\n${q.explanation}',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== 公共辅助组件 ====================

  Widget _headerCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bilingualSentenceCard(BilingualSentence s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClickableReadingText(
            text: s.en,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            s.zh,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _subSwitchChip(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _submitButton(String label) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _submitCurrent,
        child: Text(
          label,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
