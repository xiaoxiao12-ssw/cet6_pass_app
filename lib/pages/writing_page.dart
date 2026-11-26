import 'package:flutter/material.dart';
import '../data/cet6_writing_data.dart';
import '../models/cet6_models.dart';
import '../services/app_store.dart';
import '../theme/app_theme.dart';

/// Tab 4：写译（六级写作 + 段落翻译实战）
/// 作文模块：议论文/现象解释、名言哲理、图表/图画作文（题干 + 手机打字练习框 + 高分万能句式框架 + 参考范文对照）
/// 翻译模块：中国传统文化、社会经济发展、科技成就（真题练习 + 核心主题词提示 + 标准译文逐句对比）
class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  int _mode = 0; // 0 = 六级写作, 1 = 段落翻译
  int _writingIndex = 0;
  int _translationIndex = 0;

  // 写作参考区域切换：0 = 高分万能句式框架, 1 = 参考范文对照
  int _writingRefTab = 0;
  bool _showTranslationRef = false;

  late final TextEditingController _writingController;
  late final TextEditingController _translationController;

  @override
  void initState() {
    super.initState();
    _writingController = TextEditingController();
    _translationController = TextEditingController();
    _loadDrafts();
  }

  @override
  void dispose() {
    _writingController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  WritingTopic get _currentWriting => cet6WritingTopics[_writingIndex];
  TranslationTopic get _currentTranslation =>
      cet6TranslationTopics[_translationIndex];

  void _loadDrafts() {
    _writingController.text =
        AppStore.instance.getWritingDraft(_currentWriting.id);
    _translationController.text =
        AppStore.instance.getTranslationDraft(_currentTranslation.id);
  }

  int _countEnglishWords(String text) {
    return RegExp(r"[A-Za-z0-9'-]+").allMatches(text).length;
  }

  void _selectWritingTopic(int idx) {
    if (_writingIndex == idx) return;
    setState(() {
      _writingIndex = idx;
      _writingController.text =
          AppStore.instance.getWritingDraft(_currentWriting.id);
    });
  }

  void _selectTranslationTopic(int idx) {
    if (_translationIndex == idx) return;
    setState(() {
      _translationIndex = idx;
      _showTranslationRef = false;
      _translationController.text =
          AppStore.instance.getTranslationDraft(_currentTranslation.id);
    });
  }

  void _insertTextIntoController(
    TextEditingController controller,
    String snippet,
    Future<void> Function(String) onSave,
  ) {
    final current = controller.text;
    final sep = current.isEmpty || current.endsWith(' ') || current.endsWith('\n')
        ? ''
        : ' ';
    final updated = '$current$sep$snippet';
    controller.text = updated;
    controller.selection = TextSelection.collapsed(offset: updated.length);
    onSave(updated);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部模块二分切换：六级写作 | 段落翻译
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: _topToggleButton('六级写作 (三大体裁)', _mode == 0, () {
                  setState(() => _mode = 0);
                }),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _topToggleButton('段落翻译 (三大主题)', _mode == 1, () {
                  setState(() => _mode = 1);
                }),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: _mode == 0 ? _buildWritingView() : _buildTranslationView(),
        ),
      ],
    );
  }

  Widget _topToggleButton(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceSubtle,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ==================== 作文模块 (Writing) ====================

  Widget _buildWritingView() {
    final topic = _currentWriting;
    final wordCount = _countEnglishWords(_writingController.text);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 26),
      children: [
        // 三大常考体裁切换
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(cet6WritingTopics.length, (i) {
              final t = cet6WritingTopics[i];
              final active = i == _writingIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => _selectWritingTopic(i),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primarySoft : AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: active ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      t.genreLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // 真题题干卡片
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      topic.genreLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      topic.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                topic.directions,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
              ),
              if (topic.chartItems != null && topic.chartItems!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildMinimalChart(topic.chartTitle ?? '', topic.chartItems!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 手机直接打字实战区（自动保存本地草稿 + 实时英文词数统计）
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
              Row(
                children: [
                  const Text(
                    '实战写作练习区',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '已写 $wordCount 词（目标 150–200）',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (wordCount >= 150 && wordCount <= 220)
                          ? AppColors.success
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _writingController,
                maxLines: 7,
                minLines: 5,
                onChanged: (val) {
                  AppStore.instance.saveWritingDraft(topic.id, val);
                  setState(() {});
                },
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: '直接在此输入你的六级英文作文，内容自动离线保存...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.save_outlined,
                      size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  const Text(
                    '草稿已自动保存在本地',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  if (_writingController.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        _writingController.clear();
                        AppStore.instance.saveWritingDraft(topic.id, '');
                        setState(() {});
                      },
                      child: const Text(
                        '清空草稿',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 参考区切换：高分万能句式框架 vs 参考范文对照
        Row(
          children: [
            Expanded(
              child: _refTabChip('高分万能句式框架', _writingRefTab == 0, () {
                setState(() => _writingRefTab = 0);
              }),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _refTabChip('参考范文对照', _writingRefTab == 1, () {
                setState(() => _writingRefTab = 1);
              }),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (_writingRefTab == 0)
          ...topic.templates.map(
            (tpl) => Container(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tpl.stage,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _insertTextIntoController(
                          _writingController,
                          tpl.pattern,
                          (val) =>
                              AppStore.instance.saveWritingDraft(topic.id, val),
                        ),
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '插入练习框',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tpl.pattern,
                    style: const TextStyle(
                      fontSize: 13.8,
                      height: 1.55,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '提分要点：${tpl.usageNote}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
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
                  '六级高分参考范文',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.modelEssayEn,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.65,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                const Text(
                  '参考译文',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  topic.modelEssayZh,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '范文亮点表达',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: topic.keyExpressions
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMinimalChart(String title, List<ChartBarItem> items) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map((item) {
            final isNewYear = item.label.contains('2026');
            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                children: [
                  SizedBox(
                    width: 112,
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (item.value / 100).clamp(0.0, 1.0),
                        minHeight: 11,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isNewYear
                              ? AppColors.primary
                              : AppColors.accentBlue.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 34,
                    child: Text(
                      item.unitText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: isNewYear
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
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

  // ==================== 翻译模块 (Translation) ====================

  Widget _buildTranslationView() {
    final topic = _currentTranslation;
    final wordCount = _countEnglishWords(_translationController.text);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 26),
      children: [
        // 三大必考主题切换
        Row(
          children: List.generate(cet6TranslationTopics.length, (i) {
            final t = cet6TranslationTopics[i];
            final active = i == _translationIndex;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: i == cet6TranslationTopics.length - 1 ? 0 : 8,
                ),
                child: InkWell(
                  onTap: () => _selectTranslationTopic(i),
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
                      t.themeLabel,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),

        // 汉译英原文卡片
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
              Text(
                '${topic.themeLabel} · ${topic.title}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                topic.sourceZh,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.7,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 核心主题词提示卡片（点击词条可直接插入练习框）
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
                '核心主题词高频译法（点击可插入下方译文框）',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: topic.keyTerms.map((term) {
                  return InkWell(
                    onTap: () => _insertTextIntoController(
                      _translationController,
                      term.en,
                      (val) =>
                          AppStore.instance.saveTranslationDraft(topic.id, val),
                    ),
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12),
                          children: [
                            TextSpan(
                              text: '${term.zh}  ',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: term.en,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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

        // 翻译输入区
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
              Row(
                children: [
                  const Text(
                    '你的英文译文',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '已写 $wordCount 词',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _translationController,
                maxLines: 6,
                minLines: 4,
                onChanged: (val) {
                  AppStore.instance.saveTranslationDraft(topic.id, val);
                  setState(() {});
                },
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  hintText: '尝试独立翻译上述中文段落，输入内容自动离线保存...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  onPressed: () =>
                      setState(() => _showTranslationRef = !_showTranslationRef),
                  child: Text(
                    _showTranslationRef ? '收起标准译文逐句对比' : '展开标准译文逐句对比',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_showTranslationRef) ...[
          const SizedBox(height: 12),
          ...List.generate(topic.sentencePairs.length, (idx) {
            final pair = topic.sentencePairs[idx];
            return Container(
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
                  Text(
                    '第 ${idx + 1} 句 · 原文',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pair.zh,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '高分标准译文',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pair.en,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '译法解析：${pair.note}',
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _refTabChip(String label, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 9),
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
