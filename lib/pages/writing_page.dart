import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/cet6_writing_data.dart';
import '../models/study_models.dart';
import '../services/study_storage_service.dart';
import '../theme/app_theme.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  bool _isEssayMode = true; // true=高分作文三段式填空, false=传统文化翻译词库与演练
  int _templateIndex = 0;
  bool _showReferenceEssay = false;
  final Map<String, TextEditingController> _controllers = {};

  // 翻译模块状态
  String _selectedTermCat = '全部';
  final Map<String, TextEditingController> _drillCtrls = {};
  final Set<String> _revealedDrills = {};

  @override
  void initState() {
    super.initState();
    _initControllersForTemplate();
    for (final d in cet6TranslationDrills) {
      _drillCtrls[d.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final c in _drillCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  WritingTemplate get _template => cet6WritingTemplates[_templateIndex];

  Future<void> _initControllersForTemplate() async {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    final saved = await StudyStorageService.loadWritingDraft(_template.id);
    for (final b in _template.blanks) {
      _controllers[b.key] = TextEditingController(text: saved[b.key] ?? '');
    }
    if (mounted) setState(() {});
  }

  String _assembleEssay() {
    String body = _template.templateBody;
    for (final b in _template.blanks) {
      final val = _controllers[b.key]?.text.trim() ?? '';
      body = body.replaceAll(
        '{{${b.key}}}',
        val.isEmpty ? '【待填：${b.label}】' : val,
      );
    }
    return body;
  }

  int _countEnglishWords(String text) {
    final cleaned = text.replaceAll(RegExp(r'【[^】]*】'), ' ');
    final matches = RegExp(r'[A-Za-z0-9\-\’]+').allMatches(cleaned);
    return matches.length;
  }

  void _fillSampleBlanks() {
    HapticFeedback.lightImpact();
    for (final b in _template.blanks) {
      _controllers[b.key]?.text = b.sampleFill;
    }
    setState(() {});
  }

  Future<void> _saveDraft() async {
    HapticFeedback.mediumImpact();
    final map = <String, String>{};
    for (final b in _template.blanks) {
      map[b.key] = _controllers[b.key]?.text.trim() ?? '';
    }
    await StudyStorageService.saveWritingDraft(_template.id, map);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 仿写作文草稿已本地保存，打卡活跃度 +1！'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('写译救命模板 · 213分保底')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部切换：作文模板填空 vs 翻译高频替换库
            Container(
              padding: const EdgeInsets.all(5),
              decoration: AppTheme.cardDecoration(isDark, radius: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _segBtn(
                      '✍️ 作文三段式填空',
                      _isEssayMode,
                      isDark,
                      () => setState(() => _isEssayMode = true),
                    ),
                  ),
                  Expanded(
                    child: _segBtn(
                      '🌏 翻译平替词库 & 实战',
                      !_isEssayMode,
                      isDark,
                      () => setState(() => _isEssayMode = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            if (_isEssayMode)
              _buildEssayWorkshop(isDark)
            else
              _buildTranslationStudio(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildEssayWorkshop(bool isDark) {
    final primary = AppTheme.primary(isDark);
    final t = _template;
    final assembled = _assembleEssay();
    final words = _countEnglishWords(assembled);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4 大常考话题切换
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(cet6WritingTemplates.length, (i) {
              final item = cet6WritingTemplates[i];
              final sel = i == _templateIndex;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _templateIndex = i;
                      _showReferenceEssay = false;
                    });
                    _initControllersForTemplate();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? primary : AppTheme.surface(isDark),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item.topic,
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

        // 策略卡片
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark, radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '🎯 ${t.scoreStrategy}',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.45,
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 在线填空仿写区
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark, radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '1. 填入你的主题短语（自动生成 150+ 词高分作文）',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...t.blanks.map((b) {
                final ctrl = _controllers[b.key];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: ctrl,
                    onChanged: (_) => setState(() {}),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary(isDark),
                    ),
                    decoration: InputDecoration(
                      labelText: b.label,
                      hintText: b.placeholder,
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary(isDark),
                      ),
                      filled: true,
                      fillColor: AppTheme.subtle(isDark),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 11),
                    ),
                  ),
                );
              }),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _fillSampleBlanks,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('一键填入高分示例',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveDraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('保存我的仿写',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 实时合成的三段式作文预览 + 字数统计
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark, radius: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '2. 实时合成成文预览',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: (words >= 150 ? AppTheme.mintGreen : AppTheme.warmAmber)
                          .withOpacity(0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$words 词（六级要求 150~200 词）',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: words >= 150 ? AppTheme.mintGreen : AppTheme.warmAmber,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: AppTheme.pillDecoration(isDark, radius: 14),
                child: Text(
                  assembled,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.65,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _showReferenceEssay = !_showReferenceEssay);
                  },
                  icon: Icon(
                    _showReferenceEssay
                        ? Icons.expand_less_rounded
                        : Icons.compare_arrows_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _showReferenceEssay ? '收起高分参考范文对比' : '一键对比高分参考范文 & 加分句',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.mintGreen,
                    side: const BorderSide(color: AppTheme.mintGreen),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                  ),
                ),
              ),
              if (_showReferenceEssay) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.mintGreen.withOpacity(isDark ? 0.14 : 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏆 参考高分范文（预计 85+ / 106.5）',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.mintGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.referenceEssay,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: AppTheme.textPrimary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ...t.upgradeSentences.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '✨ $s',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationStudio(bool isDark) {
    final primary = AppTheme.primary(isDark);
    final cats = ['全部', '传统文化', '科技基建', '生态环保', '经济民生'];
    final terms = _selectedTermCat == '全部'
        ? cet6TranslationTerms
        : cet6TranslationTerms.where((t) => t.category == _selectedTermCat).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 分类筛选
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cats.map((cat) {
              final sel = _selectedTermCat == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedTermCat = cat);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? primary : AppTheme.surface(isDark),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: sel ? Colors.white : AppTheme.textPrimary(isDark),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // 高频词 + 425救命平替对照卡片
        Text(
          '🔥 六级翻译高频词 + 不会拼时的「425 救命平替」',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 8),

        ...terms.map(
          (term) => Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration(isDark, radius: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      term.zh,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary(isDark),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: AppTheme.pillDecoration(isDark, radius: 8),
                      child: Text(
                        term.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textSecondary(isDark),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  '🏆 高分表达：${term.advancedEn}',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '🛟 425救命平替：${term.rescueEn}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.mintGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // 段落翻译实战演练
        Text(
          '📝 真题段落仿译演练（在线写完一键对比范文）',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 10),

        ...cet6TranslationDrills.map((d) {
          final revealed = _revealedDrills.contains(d.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: AppTheme.cardDecoration(isDark, radius: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${d.title}（${d.category}）',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: AppTheme.pillDecoration(isDark, radius: 13),
                  child: Text(
                    d.chinesePrompt,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary(isDark),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _drillCtrls[d.id],
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary(isDark),
                  ),
                  decoration: InputDecoration(
                    hintText: '试着把上面的中文拆成简单句翻译出来（绝不留空！）',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary(isDark),
                    ),
                    filled: true,
                    fillColor: AppTheme.subtle(isDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        if (revealed) {
                          _revealedDrills.remove(d.id);
                        } else {
                          _revealedDrills.add(d.id);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                    ),
                    child: Text(
                      revealed ? '收起参考译文' : '一键对比高分参考译文 & 拆句技巧',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                if (revealed) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppTheme.mintGreen.withOpacity(isDark ? 0.14 : 0.09),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✅ 参考高分译文：',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.mintGreen,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          d.referenceEn,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.55,
                            color: AppTheme.textPrimary(isDark),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...d.keyTips.map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Text(
                              '💡 $tip',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _segBtn(
    String label,
    bool selected,
    bool isDark,
    VoidCallback onTap,
  ) {
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
}
