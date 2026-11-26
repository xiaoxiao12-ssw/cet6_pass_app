import 'package:flutter/material.dart';
import '../models/cet6_models.dart';
import '../services/app_store.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// Tab 1：背词（严格锚定“六级核心高频词库”）
/// 极简记忆卡片：单词 + 音标 + 本地 TTS 英语朗读 + 1~2 个六级常考释义 + 1 句真题例句及译文
/// 底部仅两个按钮：“不认识（今日重学）”与“已掌握（进入艾宾浩斯复习）”
class VocabPage extends StatefulWidget {
  const VocabPage({super.key});

  @override
  State<VocabPage> createState() => _VocabPageState();
}

class _VocabPageState extends State<VocabPage> {
  bool _wordbookOnly = false;
  List<VocabItem> _sessionQueue = [];
  int _currentIndex = 0;
  String? _feedbackHint;

  @override
  void initState() {
    super.initState();
    AppStore.instance.addListener(_onStoreChanged);
    _rebuildQueue();
  }

  @override
  void dispose() {
    AppStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (!mounted) return;
    // 仅在队列为空（例如初次加载完或从 Tab 3 新增了生词本）时自动重建，避免打断当前卡片节奏
    if (_sessionQueue.isEmpty) {
      _rebuildQueue();
    } else {
      setState(() {});
    }
  }

  void _rebuildQueue() {
    final queue = AppStore.instance.buildVocabQueue(wordbookOnly: _wordbookOnly);
    setState(() {
      _sessionQueue = queue;
      _currentIndex = 0;
      _feedbackHint = null;
    });
  }

  void _switchSource(bool wordbookOnly) {
    if (_wordbookOnly == wordbookOnly) return;
    TtsService.instance.stop();
    setState(() {
      _wordbookOnly = wordbookOnly;
    });
    _rebuildQueue();
  }

  Future<void> _handleUnknown(VocabItem word) async {
    await TtsService.instance.stop();
    await AppStore.instance.markVocabUnknown(word.id);
    if (!mounted) return;

    setState(() {
      _feedbackHint = '「${word.word}」已加入今日重学队列，稍后再次巩固';
      // 从当前位置移出并插入到后面第 3 张之后，实现真正“今日重学”
      if (_currentIndex < _sessionQueue.length) {
        final item = _sessionQueue.removeAt(_currentIndex);
        final insertAt = (_currentIndex + 3).clamp(0, _sessionQueue.length);
        _sessionQueue.insert(insertAt, item);
        if (_currentIndex >= _sessionQueue.length) {
          _currentIndex = 0;
        }
      }
    });
  }

  Future<void> _handleMastered(VocabItem word) async {
    await TtsService.instance.stop();
    final nextDays = await AppStore.instance.markVocabMastered(word.id);
    if (!mounted) return;

    setState(() {
      _feedbackHint = '「${word.word}」已掌握，艾宾浩斯计划 $nextDays 天后复习';
      if (_currentIndex < _sessionQueue.length) {
        _sessionQueue.removeAt(_currentIndex);
        if (_currentIndex >= _sessionQueue.length && _sessionQueue.isNotEmpty) {
          _currentIndex = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final todayCount = store.todayStudiedCount;
    final goal = store.dailyGoal;
    final progressRatio = (todayCount / goal).clamp(0.0, 1.0);

    return Column(
      children: [
        // 顶部克制控制栏：词库切换 + 今日背词进度 + JSON 扩展入口
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          child: Column(
            children: [
              Row(
                children: [
                  _sourceChip(
                    label: '六级核心词 (${store.allVocab.length})',
                    selected: !_wordbookOnly,
                    onTap: () => _switchSource(false),
                  ),
                  const SizedBox(width: 8),
                  _sourceChip(
                    label: '生词本 (${store.wordbookIds.length})',
                    selected: _wordbookOnly,
                    onTap: () => _switchSource(true),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _showJsonImportDialog(context),
                    icon: const Icon(
                      Icons.file_upload_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    tooltip: '导入本地 JSON 扩展词库',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '今日进度 $todayCount / $goal',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '已掌握 ${store.masteredCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '待复习 ${store.dueReviewCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '本轮余 ${_sessionQueue.length} 词',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 4,
                  backgroundColor: AppColors.surfaceSubtle,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // 极简提示条（仅操作后短暂展示艾宾浩斯排期反馈）
        if (_feedbackHint != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: AppColors.primarySoft,
            child: Text(
              _feedbackHint!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // 中央极简记忆卡片区域
        Expanded(
          child: _sessionQueue.isEmpty
              ? _buildEmptyState()
              : _buildFlashcardArea(_sessionQueue[_currentIndex]),
        ),
      ],
    );
  }

  Widget _sourceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardArea(VocabItem word) {
    final store = AppStore.instance;
    final progress = store.getVocabProgress(word.id);
    final inWordbook = store.isInWordbook(word.id);

    String statusTag = '六级核心新词';
    Color tagBg = AppColors.primarySoft;
    Color tagFg = AppColors.primary;
    if (progress != null) {
      if (progress.stage == 0) {
        statusTag = '今日重学 · 第 ${progress.wrongCount} 次';
        tagBg = AppColors.dangerSoft;
        tagFg = AppColors.danger;
      } else {
        statusTag = '艾宾浩斯复习 · 第 ${progress.stage} 轮';
        tagBg = AppColors.warningSoft;
        tagFg = AppColors.warning;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        children: [
          // 极简卡片：仅保留单词 + 音标 + TTS朗读 + 1~2个常考释义 + 1句真题例句及译文
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: tagBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusTag,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: tagFg,
                            ),
                          ),
                        ),
                        if (word.isCustom) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '扩展词',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        IconButton(
                          onPressed: () => store.toggleWordbook(word.id),
                          icon: Icon(
                            inWordbook
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            size: 21,
                            color: inWordbook
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                          tooltip: inWordbook ? '移出生词本' : '加入生词本',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // 1. 单词
                    Text(
                      word.word,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2. 音标 + 本地 TTS 英语朗读按钮
                    Row(
                      children: [
                        if (word.phonetic.isNotEmpty) ...[
                          Text(
                            word.phonetic,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        InkWell(
                          onTap: () => TtsService.instance.speakText(
                            word.word,
                            speed: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.volume_up_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '朗读',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(height: 1),
                    ),

                    // 3. 1~2 个六级真题常考释义
                    const Text(
                      '六级常考释义',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...word.meanings.take(2).map(
                          (m) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              m,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),

                    const SizedBox(height: 16),

                    // 4. 1 句真题例句及中文翻译
                    if (word.exampleEn.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '真题语境例句',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () => TtsService.instance.speakText(
                                    word.exampleEn,
                                    speed: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.play_circle_outline_rounded,
                                      size: 18,
                                      color: AppColors.accentBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              word.exampleEn,
                              style: const TextStyle(
                                fontSize: 14.5,
                                height: 1.6,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (word.exampleZh.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                word.exampleZh,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 底部严格仅保留两个按钮：“不认识（今日重学）”与“已掌握（进入艾宾浩斯复习）”
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.45),
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _handleUnknown(word),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '不认识',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '今日重学',
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _handleMastered(word),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '已掌握',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '进入艾宾浩斯复习',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _wordbookOnly
                  ? Icons.bookmark_outline_rounded
                  : Icons.check_circle_outline_rounded,
              size: 46,
              color: AppColors.primary.withValues(alpha: 0.65),
            ),
            const SizedBox(height: 12),
            Text(
              _wordbookOnly ? '生词本暂无待背词条' : '当前词库已全部进入艾宾浩斯复习计划',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _wordbookOnly
                  ? '在「阅读」板块点击文章中带下划线的六级核心词，可一键加入此处集中复习。'
                  : '你也可以点击右上角导入自定义 JSON 词条继续扩展六级词库。',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            if (_wordbookOnly)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () => _switchSource(false),
                child: const Text('返回六级核心词库'),
              )
            else
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _sessionQueue = List<VocabItem>.from(AppStore.instance.allVocab);
                    _currentIndex = 0;
                  });
                },
                child: const Text('重新浏览全部词条'),
              ),
          ],
        ),
      ),
    );
  }

  void _showJsonImportDialog(BuildContext context) {
    final controller = TextEditingController();
    const sampleJson = '''[
  {
    "word": "lucrative",
    "phonetic": "/ˈluːkrətɪv/",
    "meanings": ["adj. 利润丰厚的，赚钱的"],
    "exampleEn": "Clean energy storage has become a lucrative industry.",
    "exampleZh": "清洁能源储能已成为一个利润丰厚的行业。"
  }
]''';
    String? errorMsg;

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: const Text(
                '本地 JSON 词库扩展',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '粘贴符合格式的 JSON 词条数组，导入后自动持久化保存在本地并加入背词与阅读查词词库：',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller,
                        maxLines: 7,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontFamily: 'monospace',
                        ),
                        decoration: const InputDecoration(
                          hintText: sampleJson,
                          hintMaxLines: 7,
                        ),
                      ),
                      if (errorMsg != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          errorMsg!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            controller.text = '''[
  {
    "word": "corroborate",
    "phonetic": "/kəˈrɒbəreɪt/",
    "meanings": ["v. 证实，确证（理论/说法）"],
    "exampleEn": "Independent lab tests corroborate the scientist's initial claim.",
    "exampleZh": "独立实验室测试证实了这位科学家最初的论断。"
  },
  {
    "word": "ubiquity",
    "phonetic": "/juːˈbɪkwəti/",
    "meanings": ["n. 无处不在，普遍存在"],
    "exampleEn": "The ubiquity of smartphones has altered how news spreads.",
    "exampleZh": "智能手机的普及改变了新闻的传播方式。"
  }
]''';
                            setDialogState(() => errorMsg = null);
                          },
                          child: const Text('填入示例 JSON 体验导入'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('取消'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () async {
                    final err = await AppStore.instance.importCustomVocabJson(
                      controller.text.trim(),
                    );
                    if (err != null) {
                      setDialogState(() => errorMsg = err);
                    } else {
                      if (ctx.mounted) Navigator.of(ctx).pop();
                      _rebuildQueue();
                      if (mounted) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('JSON 词条已成功导入本地六级词库'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('导入词库'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
