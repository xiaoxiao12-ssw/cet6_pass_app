import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/cet6_models.dart';
import '../services/app_store.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';

/// 阅读文章点词查词组件：自动识别并轻柔标注六级核心高频词，点击弹窗查词并一键加入 Tab 1 生词本
class ClickableReadingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const ClickableReadingText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<ClickableReadingText> createState() => _ClickableReadingTextState();
}

class _ClickableReadingTextState extends State<ClickableReadingText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    _clearRecognizers();
    super.dispose();
  }

  void _clearRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _clearRecognizers();

    final baseStyle = widget.style ??
        const TextStyle(
          fontSize: 15,
          height: 1.7,
          color: AppColors.textPrimary,
        );

    final store = AppStore.instance;
    final regex = RegExp(r"([A-Za-z]+)|([^A-Za-z]+)");
    final spans = <InlineSpan>[];

    for (final match in regex.allMatches(widget.text)) {
      final token = match.group(0) ?? '';
      final isWord = match.group(1) != null;
      if (isWord) {
        final vocab = store.lookupWord(token);
        if (vocab != null) {
          final recognizer = TapGestureRecognizer()
            ..onTap = () => showVocabLookupDialog(context, vocab);
          _recognizers.add(recognizer);

          spans.add(
            TextSpan(
              text: token,
              style: baseStyle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.accentBlue.withValues(alpha: 0.45),
                decorationStyle: TextDecorationStyle.dotted,
              ),
              recognizer: recognizer,
            ),
          );
          continue;
        }
      }
      spans.add(TextSpan(text: token, style: baseStyle));
    }

    return Text.rich(TextSpan(children: spans));
  }
}

/// 查词弹窗：展示音标、TTS 发音、六级释义、真题例句及一键加入生词本按钮
void showVocabLookupDialog(BuildContext context, VocabItem vocab) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (ctx) {
      final store = AppStore.instance;
      return ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final saved = store.isInWordbook(vocab.id);
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vocab.word,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            if (vocab.phonetic.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                vocab.phonetic,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primarySoft,
                          foregroundColor: AppColors.primary,
                        ),
                        onPressed: () => TtsService.instance.speakText(vocab.word),
                        icon: const Icon(Icons.volume_up_rounded),
                        tooltip: '英语朗读',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...vocab.meanings.take(2).map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            m,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                  if (vocab.exampleEn.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
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
                            vocab.exampleEn,
                            style: const TextStyle(
                              fontSize: 13.5,
                              height: 1.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (vocab.exampleZh.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              vocab.exampleZh,
                              style: const TextStyle(
                                fontSize: 12.5,
                                height: 1.45,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            saved ? AppColors.success : AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await store.toggleWordbook(vocab.id);
                      },
                      icon: Icon(
                        saved
                            ? Icons.bookmark_added_rounded
                            : Icons.bookmark_add_outlined,
                        size: 19,
                      ),
                      label: Text(
                        saved ? '已加入 Tab 1 生词本（点击移出）' : '一键加入 Tab 1 生词本',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
