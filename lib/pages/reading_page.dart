import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cet6_reading_data.dart';
import '../models/study_models.dart';
import '../services/study_storage_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_dialog.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  int _passageIndex = 0;
  bool _isIntensiveMode = true; // true=逐句双语精读+长难句拆解, false=纯英文模考模式
  final Map<String, int> _selectedAnswers = {};
  bool _showExplanations = false;
  Set<String> _completedIds = {};

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final ids = await StudyStorageService.loadCompletedReadings();
    if (mounted) setState(() => _completedIds = ids);
  }

  ReadingPassage get _passage => cet6ReadingPassages[_passageIndex];

  void _showWordLookupSheet(ReadingWordHint hint) {
    HapticFeedback.lightImpact();
    TtsService.instance.speak(hint.word, speed: 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppTheme.primary(isDark);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    hint.word,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    hint.phonetic,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.volume_up_rounded, color: primary),
                    onPressed: () => TtsService.instance.speak(hint.word, speed: 1.0),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: AppTheme.pillDecoration(isDark, radius: 14),
                child: Text(
                  hint.meaning,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '💡 六级速记：${hint.tip}',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warmAmber,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await StudyStorageService.addSavedWord(
                      SavedWordEntry(
                        word: hint.word,
                        phonetic: hint.phonetic,
                        meaning: hint.meaning,
                        source: '阅读精读',
                        addedAtMs: DateTime.now().millisecondsSinceEpoch,
                      ),
                    );
                    if (!ctx.mounted) return;
                    Navigator.of(ctx).pop();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('已将「${hint.word}」一键加入生词本！'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bookmark_add_rounded, size: 18),
                  label: const Text('一键加入生词本', style: TextStyle(fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completePassage() async {
    HapticFeedback.mediumImpact();
    setState(() => _showExplanations = true);
    final shouldCelebrate =
        await StudyStorageService.markReadingTaskDone(_passage.id);
    await _loadCompleted();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 本篇真题精读已打卡！今日阅读任务完成'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    if (shouldCelebrate) {
      await showDailyCelebrationDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppTheme.primary(isDark);
    final passage = _passage;
    final isDone = _completedIds.contains(passage.id);

    return Scaffold(
      appBar: AppBar(title: const Text('阅读精读 · 长难句拆解')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 篇目切换胶囊
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(cet6ReadingPassages.length, (i) {
                  final p = cet6ReadingPassages[i];
                  final sel = i == _passageIndex;
                  final done = _completedIds.contains(p.id);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _passageIndex = i;
                          _showExplanations = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 13, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? primary : AppTheme.surface(isDark),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '真题 ${i + 1}${done ? " ✓" : ""}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: sel ? Colors.white : AppTheme.textPrimary(isDark),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),

            // 2. 一键切换【纯英文模考】vs【逐句双语精读】
            Container(
              padding: const EdgeInsets.all(5),
              decoration: AppTheme.cardDecoration(isDark, radius: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _modeTab(
                      label: '🔍 逐句双语精读模式',
                      selected: _isIntensiveMode,
                      isDark: isDark,
                      onTap: () => setState(() => _isIntensiveMode = true),
                    ),
                  ),
                  Expanded(
                    child: _modeTab(
                      label: '📝 纯英文模考模式',
                      selected: !_isIntensiveMode,
                      isDark: isDark,
                      onTap: () => setState(() => _isIntensiveMode = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. 篇目标题卡 + 语法配色图例
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(isDark, radius: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          passage.topicTag,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isDone)
                        const Text(
                          '✅ 已精读打卡',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.mintGreen,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passage.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    passage.examSource,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textSecondary(isDark),
                    ),
                  ),
                  if (_isIntensiveMode) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _legendDot('主干（主谓宾）', primary),
                        _legendDot('定语/修饰成分', AppTheme.warmAmber),
                        _legendDot('状语/逻辑转折', AppTheme.mintGreen),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. 正文展示区（模考纯英文 / 精读逐句拆解）
            if (!_isIntensiveMode)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: AppTheme.cardDecoration(isDark, radius: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passage.sentences.map((s) => s.en).join('  '),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.75,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '💡 模考提示：试着先不做翻译直接做下方 2 道真题（每题 14.2 分），做完切换「双语精读模式」解剖长难句！',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // 点击生词快查区
              Container(
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.cardDecoration(isDark, radius: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ 点击本篇核心生词查释义 & 一键加入生词本：',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textSecondary(isDark),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: passage.glossary.values.map((hint) {
                        return InkWell(
                          onTap: () => _showWordLookupSheet(hint),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(isDark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              hint.word,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: primary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 逐句长难句彩色拆解卡片
              ...List.generate(passage.sentences.length, (idx) {
                final s = passage.sentences[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: AppTheme.cardDecoration(isDark, radius: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: AppTheme.pillDecoration(isDark, radius: 8),
                            child: Text(
                              '第 ${idx + 1} 句',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                color: primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => TtsService.instance.speak(s.en, speed: 0.95),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.volume_up_rounded, size: 16, color: primary),
                                const SizedBox(width: 4),
                                Text(
                                  '朗读本句',
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
                      const SizedBox(height: 10),

                      // 长难句彩色主干/定语/状语高亮
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.68,
                            color: AppTheme.textPrimary(isDark),
                          ),
                          children: s.segments.map((seg) {
                            Color? bg;
                            Color? fg;
                            FontWeight fw = FontWeight.w500;
                            if (seg.role == ClauseRole.core) {
                              bg = primary.withOpacity(isDark ? 0.25 : 0.12);
                              fg = isDark ? Colors.white : AppTheme.kleinBlue;
                              fw = FontWeight.w800;
                            } else if (seg.role == ClauseRole.modifier) {
                              bg = AppTheme.warmAmber.withOpacity(isDark ? 0.22 : 0.14);
                              fg = isDark ? const Color(0xFFFCD34D) : const Color(0xFFB45309);
                              fw = FontWeight.w700;
                            } else if (seg.role == ClauseRole.adverbial) {
                              bg = AppTheme.mintGreen.withOpacity(isDark ? 0.22 : 0.14);
                              fg = isDark ? const Color(0xFF6EE7B7) : const Color(0xFF047857);
                              fw = FontWeight.w700;
                            }
                            return TextSpan(
                              text: seg.text,
                              style: TextStyle(
                                backgroundColor: bg,
                                color: fg,
                                fontWeight: fw,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        s.zh,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary(isDark),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: AppTheme.pillDecoration(isDark, radius: 12),
                        child: Text(
                          '🦴 骨架拆解：${s.structureNote}',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary(isDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 8),

            // 5. 14.2分/题 仔细阅读实战自测
            Text(
              '🎯 仔细阅读真题演练（每题 14.2 分！）',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary(isDark),
              ),
            ),
            const SizedBox(height: 10),

            ...List.generate(passage.questions.length, (qIdx) {
              final q = passage.questions[qIdx];
              final key = '${passage.id}_$qIdx';
              final chosen = _selectedAnswers[key];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(isDark, radius: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        height: 1.4,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(q.options.length, (oIdx) {
                      final isChosen = chosen == oIdx;
                      final isCorrect = oIdx == q.correctIndex;
                      Color bg = AppTheme.subtle(isDark);
                      Color fg = AppTheme.textPrimary(isDark);
                      if (_showExplanations) {
                        if (isCorrect) {
                          bg = AppTheme.mintGreen.withOpacity(0.18);
                          fg = AppTheme.mintGreen;
                        } else if (isChosen && !isCorrect) {
                          bg = AppTheme.coralRed.withOpacity(0.18);
                          fg = AppTheme.coralRed;
                        }
                      } else if (isChosen) {
                        bg = primary.withOpacity(0.16);
                        fg = primary;
                      }
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedAnswers[key] = oIdx);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 7),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            q.options[oIdx],
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: isChosen || (_showExplanations && isCorrect)
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              color: fg,
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_showExplanations) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: AppTheme.mintGreen.withOpacity(isDark ? 0.16 : 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '✅ 解析：${q.explanation}',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.mintGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            ElevatedButton.icon(
              onPressed: _completePassage,
              icon: const Icon(Icons.task_alt_rounded, size: 19),
              label: Text(
                _showExplanations ? '已核对解析 · 再次巩固打卡' : '核对答案解析 & 完成今日精读打卡',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeTab({
    required String label,
    required bool selected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final primary = AppTheme.primary(isDark);
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : AppTheme.textSecondary(isDark),
          ),
        ),
      ),
    );
  }

  Widget _legendDot(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}
