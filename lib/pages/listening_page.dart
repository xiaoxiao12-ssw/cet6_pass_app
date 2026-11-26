import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cet6_listening_data.dart';
import '../models/study_models.dart';
import '../services/study_storage_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_dialog.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  int _trackIndex = 0;
  int _activeLineIndex = -1;
  bool _isPlaying = false;
  double _speed = 1.0; // 0.75x / 1.0x / 1.25x
  bool _singleLoop = false; // 单句循环精听开关
  bool _blindMode = true; // 原文遮罩盲听训练开关
  bool _highlightSynonyms = true; // 同义替换词高亮开关
  final Set<int> _peekedLines = {};

  final Map<String, int> _selectedAnswers = {};
  bool _showExplanations = false;
  Set<String> _completedIds = {};

  @override
  void initState() {
    super.initState();
    _loadCompleted();
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _loadCompleted() async {
    final ids = await StudyStorageService.loadCompletedListenings();
    if (mounted) setState(() => _completedIds = ids);
  }

  ListeningTrack get _track => cet6ListeningTracks[_trackIndex];

  void _stopPlayback() {
    TtsService.instance.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _playLine(int index, {bool autoAdvance = true}) async {
    if (index < 0 || index >= _track.lines.length) {
      _stopPlayback();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() {
      _activeLineIndex = index;
      _isPlaying = true;
    });
    final line = _track.lines[index];
    await TtsService.instance.speak(
      line.en,
      speed: _speed,
      onComplete: () {
        if (!mounted || !_isPlaying) return;
        if (_singleLoop) {
          _playLine(index, autoAdvance: false);
        } else if (autoAdvance && index + 1 < _track.lines.length) {
          _playLine(index + 1, autoAdvance: true);
        } else {
          setState(() => _isPlaying = false);
        }
      },
    );
  }

  void _togglePlayAll() {
    if (_isPlaying) {
      _stopPlayback();
    } else {
      final start = _activeLineIndex >= 0 && _activeLineIndex < _track.lines.length
          ? _activeLineIndex
          : 0;
      _playLine(start, autoAdvance: true);
    }
  }

  void _setSpeed(double s) {
    HapticFeedback.selectionClick();
    setState(() => _speed = s);
    TtsService.instance.setSpeed(s);
    if (_isPlaying && _activeLineIndex >= 0) {
      _playLine(_activeLineIndex, autoAdvance: !_singleLoop);
    }
  }

  Future<void> _completeListening() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _showExplanations = true;
      _blindMode = false;
    });
    final shouldCelebrate =
        await StudyStorageService.markListeningTaskDone(_track.id);
    await _loadCompleted();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 本段精听磨耳朵已打卡！今日听力任务完成'),
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
    final track = _track;
    final isDone = _completedIds.contains(track.id);

    return Scaffold(
      appBar: AppBar(title: const Text('听力盲听 · 逐句磨耳朵')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. 听力素材切换
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(cet6ListeningTracks.length, (i) {
                  final t = cet6ListeningTracks[i];
                  final sel = i == _trackIndex;
                  final done = _completedIds.contains(t.id);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        _stopPlayback();
                        setState(() {
                          _trackIndex = i;
                          _activeLineIndex = -1;
                          _peekedLines.clear();
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
                          '精听 ${i + 1}${done ? " ✓" : ""}',
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

            // 2. 离线本地英语 TTS 播放器控制台
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1538C8), AppTheme.kleinBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.kleinBlue.withOpacity(0.28),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          track.sectionType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isDone)
                        const Text(
                          '✅ 已打卡',
                          style: TextStyle(
                            color: Color(0xFF6EE7B7),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    track.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 播放主按钮 + 语速选择 (0.75x / 1.0x / 1.25x)
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _togglePlayAll,
                        icon: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 22,
                        ),
                        label: Text(
                          _isPlaying ? '暂停朗读' : '开始磨耳朵',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.kleinBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ...[0.75, 1.0, 1.25].map((spd) {
                        final on = _speed == spd;
                        return GestureDetector(
                          onTap: () => _setSpeed(spd),
                          child: Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 6),
                            decoration: BoxDecoration(
                              color: on
                                  ? AppTheme.warmAmber
                                  : Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${spd}x',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w900,
                                color: on ? const Color(0xFF1A1400) : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 三个核心精听开关：单句循环 / 原文遮罩盲听 / 同义替换高亮
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _playerToggle(
                        icon: Icons.repeat_one_rounded,
                        label: _singleLoop ? '单句循环:开' : '单句循环:关',
                        active: _singleLoop,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _singleLoop = !_singleLoop);
                        },
                      ),
                      _playerToggle(
                        icon: _blindMode
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        label: _blindMode ? '盲听遮罩:开' : '显示双语原文',
                        active: _blindMode,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _blindMode = !_blindMode);
                        },
                      ),
                      _playerToggle(
                        icon: Icons.auto_awesome_rounded,
                        label: _highlightSynonyms ? '同义替换高亮:开' : '高亮:关',
                        active: _highlightSynonyms,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _highlightSynonyms = !_highlightSynonyms);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. 逐句精听互动脚本列表（点击任意一句即可单句播/循环）
            Row(
              children: [
                Text(
                  '🎧 逐句音频脚本（点任意一句精准复读）',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...List.generate(track.lines.length, (i) {
              final line = track.lines[i];
              final isActive = _activeLineIndex == i;
              final isMasked = _blindMode && !_peekedLines.contains(i);

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: AppTheme.cardDecoration(
                  isDark,
                  radius: 18,
                  color: isActive
                      ? primary.withOpacity(isDark ? 0.22 : 0.08)
                      : null,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _playLine(i, autoAdvance: !_singleLoop),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? primary
                                    : AppTheme.subtle(isDark),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${line.speaker} · 第${i + 1}句',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: isActive
                                      ? Colors.white
                                      : AppTheme.textSecondary(isDark),
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (_blindMode)
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    if (_peekedLines.contains(i)) {
                                      _peekedLines.remove(i);
                                    } else {
                                      _peekedLines.add(i);
                                    }
                                  });
                                },
                                child: Text(
                                  isMasked ? '👁 偷看本句' : '隐藏本句',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: primary,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Icon(
                              isActive && _isPlaying
                                  ? Icons.graphic_eq_rounded
                                  : Icons.play_circle_outline_rounded,
                              size: 20,
                              color: primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (isMasked)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: AppTheme.pillDecoration(isDark, radius: 12),
                            child: Text(
                              '🙈 盲听遮罩已开启 · 先用耳朵抓关键词，听不懂点右上角“偷看本句”',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary(isDark),
                              ),
                            ),
                          )
                        else ...[
                          _buildHighlightedLine(line, isDark),
                          const SizedBox(height: 5),
                          Text(
                            line.zh,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppTheme.textSecondary(isDark),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),

            // 4. 同义替换防坑秘籍（专治“听到原词就选错”）
            if (_highlightSynonyms && track.traps.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(isDark, radius: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded,
                            color: AppTheme.warmAmber, size: 19),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '六级听力必考法则：听到原词≠答案，同义替换才是答案！',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.warmAmber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...track.traps.map(
                      (trap) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(11),
                        decoration: AppTheme.pillDecoration(isDark, radius: 13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.warmAmber.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '听到：${trap.audioWord}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.warmAmber,
                                    ),
                                  ),
                                ),
                                const Text('→', style: TextStyle(fontWeight: FontWeight.w900)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '选：${trap.answerSynonym}',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '释义：${trap.meaningZh}',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppTheme.textSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),

            // 5. 听力真题自测
            ...List.generate(track.questions.length, (qIdx) {
              final q = track.questions[qIdx];
              final key = '${track.id}_$qIdx';
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
              onPressed: _completeListening,
              icon: const Icon(Icons.hearing_rounded, size: 19),
              label: const Text(
                '核对答案解析 & 完成今日精听打卡',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
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

  Widget _buildHighlightedLine(ListeningLine line, bool isDark) {
    if (!_highlightSynonyms || line.highlightWords.isEmpty) {
      return Text(
        line.en,
        style: TextStyle(
          fontSize: 14.5,
          height: 1.55,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary(isDark),
        ),
      );
    }

    final text = line.en;
    final spans = <TextSpan>[];
    int cursor = 0;

    while (cursor < text.length) {
      int bestStart = -1;
      String? matchedWord;
      for (final kw in line.highlightWords) {
        final idx = text.toLowerCase().indexOf(kw.toLowerCase(), cursor);
        if (idx != -1 && (bestStart == -1 || idx < bestStart)) {
          bestStart = idx;
          matchedWord = text.substring(idx, idx + kw.length);
        }
      }
      if (bestStart == -1 || matchedWord == null) {
        spans.add(TextSpan(text: text.substring(cursor)));
        break;
      }
      if (bestStart > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, bestStart)));
      }
      spans.add(
        TextSpan(
          text: matchedWord,
          style: TextStyle(
            backgroundColor: AppTheme.warmAmber.withOpacity(isDark ? 0.30 : 0.24),
            color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB45309),
            fontWeight: FontWeight.w900,
          ),
        ),
      );
      cursor = bestStart + matchedWord.length;
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14.5,
          height: 1.55,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary(isDark),
        ),
        children: spans,
      ),
    );
  }

  Widget _playerToggle({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: active ? AppTheme.kleinBlue : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: active ? AppTheme.kleinBlue : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
