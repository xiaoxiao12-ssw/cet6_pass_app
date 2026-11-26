class VocabItem {
  final String id;
  final String word;
  final String phonetic;
  final List<String> meanings;
  final String exampleEn;
  final String exampleZh;
  final bool isCustom;

  const VocabItem({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.meanings,
    required this.exampleEn,
    required this.exampleZh,
    this.isCustom = false,
  });

  factory VocabItem.fromJson(Map<String, dynamic> json, {bool custom = false}) {
    final rawMeanings = json['meanings'];
    List<String> parsedMeanings;
    if (rawMeanings is List) {
      parsedMeanings = rawMeanings
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['meaning'] != null) {
      parsedMeanings = [json['meaning'].toString().trim()];
    } else {
      parsedMeanings = ['（暂无释义）'];
    }

    final wordText = (json['word'] ?? '').toString().trim();
    final idText = (json['id'] ?? 'custom_${wordText.toLowerCase()}').toString().trim();

    return VocabItem(
      id: idText.isEmpty ? 'custom_${wordText.toLowerCase()}' : idText,
      word: wordText,
      phonetic: (json['phonetic'] ?? '').toString().trim(),
      meanings: parsedMeanings,
      exampleEn: (json['exampleEn'] ?? json['example'] ?? '').toString().trim(),
      exampleZh: (json['exampleZh'] ?? json['translation'] ?? '').toString().trim(),
      isCustom: custom || (json['isCustom'] == true),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'phonetic': phonetic,
        'meanings': meanings,
        'exampleEn': exampleEn,
        'exampleZh': exampleZh,
        'isCustom': isCustom,
      };
}

/// 艾宾浩斯复习进度模型
class VocabProgress {
  /// 0 = 未掌握/今日重学；1..6 = 艾宾浩斯复习阶段（对应 1, 2, 4, 7, 15, 30 天间隔）
  final int stage;
  final int nextReviewEpochDay;
  final int wrongCount;
  final String lastStudiedDate;

  const VocabProgress({
    required this.stage,
    required this.nextReviewEpochDay,
    required this.wrongCount,
    required this.lastStudiedDate,
  });

  static const List<int> ebbinghausIntervals = [0, 1, 2, 4, 7, 15, 30];

  bool get isMastered => stage >= 1;

  factory VocabProgress.fromJson(Map<String, dynamic> json) {
    return VocabProgress(
      stage: (json['stage'] as num?)?.toInt() ?? 0,
      nextReviewEpochDay: (json['nextReviewEpochDay'] as num?)?.toInt() ?? 0,
      wrongCount: (json['wrongCount'] as num?)?.toInt() ?? 0,
      lastStudiedDate: (json['lastStudiedDate'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'stage': stage,
        'nextReviewEpochDay': nextReviewEpochDay,
        'wrongCount': wrongCount,
        'lastStudiedDate': lastStudiedDate,
      };
}

// ==================== Tab 2: 听力模型 ====================

enum ListeningSectionType {
  longConversation,
  passage,
  lecture,
}

extension ListeningSectionTypeExt on ListeningSectionType {
  String get shortLabel {
    switch (this) {
      case ListeningSectionType.longConversation:
        return '长对话';
      case ListeningSectionType.passage:
        return '听力篇章';
      case ListeningSectionType.lecture:
        return '讲话/讲座';
    }
  }

  String get fullLabel {
    switch (this) {
      case ListeningSectionType.longConversation:
        return 'Section A · 长对话 (Long Conversations)';
      case ListeningSectionType.passage:
        return 'Section B · 听力篇章 (Passages)';
      case ListeningSectionType.lecture:
        return 'Section C · 讲话/报道/讲座 (Lectures/Talks)';
    }
  }
}

class ListeningSentence {
  final String? speaker;
  final String en;
  final String zh;
  /// 若该句为某道题的答案定位句，填题号 (1-based)
  final int? locatesQuestion;

  const ListeningSentence({
    this.speaker,
    required this.en,
    required this.zh,
    this.locatesQuestion,
  });
}

class SynonymPair {
  final String original;
  final String replacement;
  final String note;

  const SynonymPair({
    required this.original,
    required this.replacement,
    required this.note,
  });
}

class ListeningQuestion {
  final int number;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String explanation;

  const ListeningQuestion({
    required this.number,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.explanation,
  });
}

class ListeningExercise {
  final String id;
  final ListeningSectionType sectionType;
  final String title;
  final String subtitle;
  final List<ListeningSentence> sentences;
  final List<ListeningQuestion> questions;
  final List<SynonymPair> synonyms;

  const ListeningExercise({
    required this.id,
    required this.sectionType,
    required this.title,
    required this.subtitle,
    required this.sentences,
    required this.questions,
    required this.synonyms,
  });
}

class ListeningRecord {
  final int correctCount;
  final int totalCount;
  final Map<int, int> selectedAnswers;
  final List<int> wrongQuestionNumbers;
  final String submittedAt;

  const ListeningRecord({
    required this.correctCount,
    required this.totalCount,
    required this.selectedAnswers,
    required this.wrongQuestionNumbers,
    required this.submittedAt,
  });

  factory ListeningRecord.fromJson(Map<String, dynamic> json) {
    final rawSelected = (json['selectedAnswers'] as Map<String, dynamic>?) ?? {};
    final selected = <int, int>{};
    rawSelected.forEach((k, v) {
      final ki = int.tryParse(k);
      if (ki != null && v is num) selected[ki] = v.toInt();
    });
    final rawWrong = (json['wrongQuestionNumbers'] as List?) ?? [];
    return ListeningRecord(
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      selectedAnswers: selected,
      wrongQuestionNumbers: rawWrong.map((e) => (e as num).toInt()).toList(),
      submittedAt: (json['submittedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'correctCount': correctCount,
        'totalCount': totalCount,
        'selectedAnswers': selectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
        'wrongQuestionNumbers': wrongQuestionNumbers,
        'submittedAt': submittedAt,
      };
}

// ==================== Tab 3: 阅读模型 ====================

enum ReadingSectionType {
  bankedCloze,
  matching,
  carefulReading,
}

extension ReadingSectionTypeExt on ReadingSectionType {
  String get shortLabel {
    switch (this) {
      case ReadingSectionType.bankedCloze:
        return '选词填空';
      case ReadingSectionType.matching:
        return '长篇匹配';
      case ReadingSectionType.carefulReading:
        return '仔细阅读';
    }
  }

  String get weightBadge {
    switch (this) {
      case ReadingSectionType.bankedCloze:
        return '15选10 · 3.55分/题 (5%)';
      case ReadingSectionType.matching:
        return '段落匹配 · 7.1分/题 (10%)';
      case ReadingSectionType.carefulReading:
        return '深度单选 · 14.2分/题 (20%)';
    }
  }

  double get scorePerQuestion {
    switch (this) {
      case ReadingSectionType.bankedCloze:
        return 3.55;
      case ReadingSectionType.matching:
        return 7.1;
      case ReadingSectionType.carefulReading:
        return 14.2;
    }
  }
}

class BilingualSentence {
  final String en;
  final String zh;

  const BilingualSentence({required this.en, required this.zh});
}

class BankedClozeOption {
  final String letter; // A..O
  final String word;
  final String posHint; // 仅在解析模式显示词性与释义

  const BankedClozeOption({
    required this.letter,
    required this.word,
    required this.posHint,
  });
}

class BankedClozeExercise {
  final String id;
  final String title;
  final String subtitle;
  /// 用 {{1}} .. {{10}} 标注 10 个空位
  final String rawPassage;
  final List<BankedClozeOption> wordBank; // 15 个词 A..O
  final List<String> answers; // 长度 10，如 ['C', 'K', ...]
  final List<String> explanations; // 长度 10
  final List<BilingualSentence> bilingualSentences;

  const BankedClozeExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rawPassage,
    required this.wordBank,
    required this.answers,
    required this.explanations,
    required this.bilingualSentences,
  });
}

class MatchingParagraph {
  final String label; // A..J
  final List<BilingualSentence> sentences;

  const MatchingParagraph({
    required this.label,
    required this.sentences,
  });

  String get fullEn => sentences.map((s) => s.en).join(' ');
}

class MatchingStatement {
  final int number;
  final String statement;
  final String answerLabel; // A..J
  final String keyPhrase;
  final String explanation;

  const MatchingStatement({
    required this.number,
    required this.statement,
    required this.answerLabel,
    required this.keyPhrase,
    required this.explanation,
  });
}

class MatchingExercise {
  final String id;
  final String title;
  final String subtitle;
  final List<MatchingParagraph> paragraphs;
  final List<MatchingStatement> statements;

  const MatchingExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.paragraphs,
    required this.statements,
  });
}

class CarefulQuestion {
  final int number;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String locateHint;
  final String explanation;

  const CarefulQuestion({
    required this.number,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.locateHint,
    required this.explanation,
  });
}

class CarefulReadingExercise {
  final String id;
  final String title;
  final String subtitle;
  final List<List<BilingualSentence>> paragraphs;
  final List<CarefulQuestion> questions;

  const CarefulReadingExercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.paragraphs,
    required this.questions,
  });
}

class ReadingRecord {
  final int correctCount;
  final int totalCount;
  final double cet6Score;
  final double maxCet6Score;
  final int elapsedSeconds;
  final Map<String, String> userAnswers;
  final List<int> wrongNumbers;
  final String submittedAt;

  const ReadingRecord({
    required this.correctCount,
    required this.totalCount,
    required this.cet6Score,
    required this.maxCet6Score,
    required this.elapsedSeconds,
    required this.userAnswers,
    required this.wrongNumbers,
    required this.submittedAt,
  });

  factory ReadingRecord.fromJson(Map<String, dynamic> json) {
    final rawAns = (json['userAnswers'] as Map<String, dynamic>?) ?? {};
    final ans = <String, String>{};
    rawAns.forEach((k, v) => ans[k] = v.toString());
    final rawWrong = (json['wrongNumbers'] as List?) ?? [];
    return ReadingRecord(
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      cet6Score: (json['cet6Score'] as num?)?.toDouble() ?? 0.0,
      maxCet6Score: (json['maxCet6Score'] as num?)?.toDouble() ?? 0.0,
      elapsedSeconds: (json['elapsedSeconds'] as num?)?.toInt() ?? 0,
      userAnswers: ans,
      wrongNumbers: rawWrong.map((e) => (e as num).toInt()).toList(),
      submittedAt: (json['submittedAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'correctCount': correctCount,
        'totalCount': totalCount,
        'cet6Score': cet6Score,
        'maxCet6Score': maxCet6Score,
        'elapsedSeconds': elapsedSeconds,
        'userAnswers': userAnswers,
        'wrongNumbers': wrongNumbers,
        'submittedAt': submittedAt,
      };
}

// ==================== Tab 4: 写译模型 ====================

enum WritingGenre {
  argumentative,
  proverb,
  chart,
}

class ChartBarItem {
  final String label;
  final double value;
  final String unitText;

  const ChartBarItem({
    required this.label,
    required this.value,
    required this.unitText,
  });
}

class WritingTemplateBlock {
  final String stage;
  final String pattern;
  final String usageNote;

  const WritingTemplateBlock({
    required this.stage,
    required this.pattern,
    required this.usageNote,
  });
}

class WritingTopic {
  final String id;
  final WritingGenre genre;
  final String genreLabel;
  final String title;
  final String directions;
  final String? chartTitle;
  final List<ChartBarItem>? chartItems;
  final List<WritingTemplateBlock> templates;
  final String modelEssayEn;
  final String modelEssayZh;
  final List<String> keyExpressions;

  const WritingTopic({
    required this.id,
    required this.genre,
    required this.genreLabel,
    required this.title,
    required this.directions,
    this.chartTitle,
    this.chartItems,
    required this.templates,
    required this.modelEssayEn,
    required this.modelEssayZh,
    required this.keyExpressions,
  });
}

enum TranslationTheme {
  culture,
  economy,
  tech,
}

class ThemeTerm {
  final String zh;
  final String en;

  const ThemeTerm({required this.zh, required this.en});
}

class TranslationSentencePair {
  final String zh;
  final String en;
  final String note;

  const TranslationSentencePair({
    required this.zh,
    required this.en,
    required this.note,
  });
}

class TranslationTopic {
  final String id;
  final TranslationTheme theme;
  final String themeLabel;
  final String title;
  final String sourceZh;
  final List<ThemeTerm> keyTerms;
  final List<TranslationSentencePair> sentencePairs;

  const TranslationTopic({
    required this.id,
    required this.theme,
    required this.themeLabel,
    required this.title,
    required this.sourceZh,
    required this.keyTerms,
    required this.sentencePairs,
  });
}
