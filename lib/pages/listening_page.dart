import 'package:flutter/material.dart';
import '../data/cet6_listening_data.dart';
import '../models/cet6_models.dart';
import '../services/app_store.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// Tab 2：听力（完整覆盖六级听力三大真实题型）
/// ① 长对话 (Long Conversations)  ② 听力篇章 (Passages)  ③ 讲话/报道/讲座 (Lectures/Talks)
/// 支持 flutter_tts 0.8x / 1.0x / 1.2x 播放、交卷判分、逐句对照原文 + 答案定位句高亮 + 同义替换词解析
class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  ListeningSectionType _selectedType = ListeningSectionType.longConversation;
  String _selectedExerciseId = cet6ListeningExercises.first.id;
  double _speed = 1.0;

  bool _isPlaying = false;
  int _activeSentenceIndex = -1;

  // 当前做题状态
  final Map<int, int> _draftAnswers = {};
  bool _submitted = false;
  int _reviewSubTab = 0; // 0 = 题目判分, 1 = 逐句精听与同义替换

  List<ListeningExercise> get _sectionExercises => cet6ListeningExercises
      .where((e) => e.sectionType == _selectedType)
      .toList();

  ListeningExercise get _currentExercise => cet6ListeningExercises.firstWhere(
        (e) => e.id == _selectedExerciseId,
        orElse: () => _sectionExercises.first,
      );

  @override
  void initState() {
    super.initState();
    _loadSavedState(_selectedExerciseId);
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  void _loadSavedState(String exerciseId) {
    final record = AppStore.instance.getListeningRecord(exerciseId);
    _draftAnswers.clear();
    if (record != null) {
      _draftAnswers.addAll(record.selectedAnswers);
      _submitted = true;
    } else {
      _submitted = false;
    }
    _reviewSubTab = 0;
  }

  void _selectSection(ListeningSectionType type) {
    if (_selectedType == type) return;
    _stopPlayback();
    final list =
        cet6ListeningExercises.where((e) => e.sectionType == type).toList();
    setState(() {
      _selectedType = type;
      _selectedExerciseId = list.first.id;
      _loadSavedState(_selectedExerciseId);
    });
  }

  void _selectExercise(String id) {
    if (_selectedExerciseId == id) return;
    _stopPlayback();
    setState(() {
      _selectedExerciseId = id;
      _loadSavedState(id);
    });
  }

  Future<void> _togglePlay({int startFrom = 0}) async {
    if (_isPlaying && startFrom == 0) {
      await _stopPlayback();
      return;
    }

    final ex = _currentExercise;
    final texts = ex.sentences.map((s) => s.en).toList();
    setState(() {
      _isPlaying = true;
      _activeSentenceIndex = startFrom;
    });

    await TtsService.instance.playQueue(
      texts,
      startIndex: startFrom,
      speed: _speed,
      onSentenceStart: (idx) {
        if (!mounted) return;
        setState(() {
          _isPlaying = true;
          _activeSentenceIndex = idx;
        });
      },
      onQueueDone: () {
        if (!mounted) return;
        setState(() {
          _isPlaying = false;
          _activeSentenceIndex = -1;
        });
      },
    );
  }

  Future<void> _stopPlayback() async {
    await TtsService.instance.stop();
    if (!mounted) return;
    setState(() {
      _isPlaying = false;
      _activeSentenceIndex = -1;
    });
  }

  Future<void> _changeSpeed(double newSpeed) async {
    setState(() => _speed = newSpeed);
    await TtsService.instance.setSpeed(newSpeed);
    // 若正在播放，从当前句平滑应用新语速
    if (_isPlaying && _activeSentenceIndex >= 0) {
      await _togglePlay(startFrom: _activeSentenceIndex);
    }
  }

  Future<void> _speakSingleSentence(int index) async {
    final ex = _currentExercise;
    if (index < 0 || index >= ex.sentences.length) return;
    setState(() {
      _isPlaying = false;
      _activeSentenceIndex = index;
    });
    await TtsService.instance.speakText(ex.sentences[index].en, speed: _speed);
  }

  Future<void> _submitAnswers() async {
    final ex = _currentExercise;
    if (_draftAnswers.length < ex.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '还有 ${ex.questions.length - _draftAnswers.length} 题未作答，请全部选择后交卷',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    int correct = 0;
    final wrongNumbers = <int>[];
    for (final q in ex.questions) {
      final picked = _draftAnswers[q.number];
      if (picked == q.answerIndex) {
        correct++;
      } else {
        wrongNumbers.add(q.number);
      }
    }

    final record = ListeningRecord(
      correctCount: correct,
      totalCount: ex.questions.length,
      selectedAnswers: Map<int, int>.from(_draftAnswers),
      wrongQuestionNumbers: wrongNumbers,
      submittedAt: AppStore.todayKey,
    );

    await AppStore.instance.saveListeningRecord(ex.id, record);
    if (!mounted) return;
    setState(() {
      _submitted = true;
      _reviewSubTab = 0;
    });
  }

  void _resetExercise() {
    _stopPlayback();
    setState(() {
      _draftAnswers.clear();
      _submitted = false;
      _reviewSubTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ex = _currentExercise;
    final savedRecord = AppStore.instance.getListeningRecord(ex.id);

    return Column(
      children: [
        // 1. 三大真实题型切换栏
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: ListeningSectionType.values.map((type) {
                  final selected = _selectedType == type;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: type == ListeningSectionType.lecture ? 0 : 8,
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
              const SizedBox(height: 10),
              // 题目列表横向切换
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _sectionExercises.map((item) {
                    final active = item.id == ex.id;
                    final rec = AppStore.instance.getListeningRecord(item.id);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _selectExercise(item.id),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySoft
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.title.split(' · ').first,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: active
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                              ),
                              if (rec != null) ...[
                                const SizedBox(width: 6),
                                Text(
                                  '${rec.correctCount}/${rec.totalCount}',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 2. TTS 听力播放器控制条（支持 0.8x / 1.0x / 1.2x 语速）
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 36,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _togglePlay(),
                      icon: Icon(
                        _isPlaying
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        size: 19,
                      ),
                      label: Text(
                        _isPlaying ? '停止播放' : '播放听力',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 0.8x / 1.0x / 1.2x 语速切换
                  ...[0.8, 1.0, 1.2].map((sp) {
                    final active = (_speed - sp).abs() < 0.05;
                    return Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () => _changeSpeed(sp),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primarySoft
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  active ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            '${sp.toStringAsFixed(1)}x',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
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
                  Text(
                    _activeSentenceIndex >= 0
                        ? '${_activeSentenceIndex + 1}/${ex.sentences.length} 句'
                        : '${ex.sentences.length} 句',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${ex.title}  ·  ${ex.subtitle}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 交卷后提供：题目判分 vs 逐句精听原文+同义替换 双视图切换
        if (_submitted)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                _subTabChip('题目与解析', 0),
                const SizedBox(width: 8),
                _subTabChip('逐句原文 & 同义替换', 1),
                const Spacer(),
                if (savedRecord != null)
                  Text(
                    '得分 ${savedRecord.correctCount}/${savedRecord.totalCount}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _resetExercise,
                  child: const Text(
                    '重做',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // 3. 主内容区
        Expanded(
          child: _submitted && _reviewSubTab == 1
              ? _buildIntensiveTranscriptView(ex)
              : _buildQuestionsView(ex),
        ),
      ],
    );
  }

  Widget _subTabChip(String label, int index) {
    final selected = _reviewSubTab == index;
    return InkWell(
      onTap: () => setState(() => _reviewSubTab = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionsView(ListeningExercise ex) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        ...ex.questions.map((q) => _buildQuestionCard(q)),
        const SizedBox(height: 8),
        if (!_submitted)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _submitAnswers,
              child: const Text(
                '交卷判分并查看精听解析',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => setState(() => _reviewSubTab = 1),
              icon: const Icon(Icons.subtitles_outlined, size: 18),
              label: const Text(
                '进入逐句对照原文 & 答案定位高亮',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(ListeningQuestion q) {
    final picked = _draftAnswers[q.number];
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
            'Q${q.number}. ${q.question}',
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(q.options.length, (optIdx) {
            final isSelected = picked == optIdx;
            final isCorrect = q.answerIndex == optIdx;

            Color bg = AppColors.background;
            Color border = AppColors.border;
            Color textColor = AppColors.textPrimary;

            if (_submitted) {
              if (isCorrect) {
                bg = AppColors.successSoft;
                border = AppColors.success;
                textColor = AppColors.success;
              } else if (isSelected && !isCorrect) {
                bg = AppColors.dangerSoft;
                border = AppColors.danger;
                textColor = AppColors.danger;
              }
            } else if (isSelected) {
              bg = AppColors.primarySoft;
              border = AppColors.primary;
              textColor = AppColors.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: InkWell(
                onTap: _submitted
                    ? null
                    : () => setState(() => _draftAnswers[q.number] = optIdx),
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
                      fontWeight:
                          (isSelected || (_submitted && isCorrect))
                              ? FontWeight.w600
                              : FontWeight.w400,
                      color: textColor,
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
                '解析：${q.explanation}',
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
  }

  Widget _buildIntensiveTranscriptView(ListeningExercise ex) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            '逐句精听对照（点击任意句子可单句复读 · 浅橙高亮为答案定位句）',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...List.generate(ex.sentences.length, (i) {
          final s = ex.sentences[i];
          final isLocated = s.locatesQuestion != null;
          final isSpeaking = _activeSentenceIndex == i;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => _speakSingleSentence(i),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: isLocated ? AppColors.warningSoft : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSpeaking
                        ? AppColors.primary
                        : (isLocated
                            ? AppColors.warning.withValues(alpha: 0.55)
                            : AppColors.border),
                    width: isSpeaking ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (s.speaker != null)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              s.speaker!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        if (isLocated)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Q${s.locatesQuestion} 答案定位句',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const Spacer(),
                        Icon(
                          isSpeaking
                              ? Icons.graphic_eq_rounded
                              : Icons.volume_up_outlined,
                          size: 16,
                          color: isSpeaking
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.en,
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.55,
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
              ),
            ),
          );
        }),

        const SizedBox(height: 10),
        // 常见同义替换词解析卡片
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
              const Row(
                children: [
                  Icon(Icons.compare_arrows_rounded,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    '六级听力常见同义替换词解析',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...ex.synonyms.map(
                (pair) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textPrimary,
                          ),
                          children: [
                            TextSpan(
                              text: pair.original,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const TextSpan(text: '  →  '),
                            TextSpan(
                              text: pair.replacement,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        pair.note,
                        style: const TextStyle(
                          fontSize: 12,
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
      ],
    );
  }
}
