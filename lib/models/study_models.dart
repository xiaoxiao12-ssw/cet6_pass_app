/// 六级真题高频救命词条模型
class VocabWord {
  final String id;
  final String word;
  final String phonetic;
  final int frequency; // 真题出现频次
  final String coreMeaning; // 真题最高频考义（1~2个）
  final String exampleEn; // 真题原句
  final String exampleZh; // 大白话翻译
  final String mnemonic; // 词根词缀助记口诀
  final String tag; // 极高频 / 阅读必考 / 听力高频 / 写作加分

  const VocabWord({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.frequency,
    required this.coreMeaning,
    required this.exampleEn,
    required this.exampleZh,
    required this.mnemonic,
    required this.tag,
  });
}

/// 艾宾浩斯记忆进度状态（本地持久化）
class EbbinghausProgress {
  final String wordId;
  final int stage; // 0=新词/重学, 1..6=艾宾浩斯复习阶段
  final int nextReviewMs;
  final int wrongCount;

  const EbbinghausProgress({
    required this.wordId,
    required this.stage,
    required this.nextReviewMs,
    required this.wrongCount,
  });

  bool get isMastered => stage >= 2;

  Map<String, dynamic> toJson() => {
        'wordId': wordId,
        'stage': stage,
        'nextReviewMs': nextReviewMs,
        'wrongCount': wrongCount,
      };

  factory EbbinghausProgress.fromJson(Map<String, dynamic> json) =>
      EbbinghausProgress(
        wordId: (json['wordId'] ?? '').toString(),
        stage: (json['stage'] as num?)?.toInt() ?? 0,
        nextReviewMs: (json['nextReviewMs'] as num?)?.toInt() ?? 0,
        wrongCount: (json['wrongCount'] as num?)?.toInt() ?? 0,
      );
}

/// 阅读长难句语法成分切片
enum ClauseRole {
  plain,    // 普通连接文本
  core,     // 主干（主谓宾）- 克莱因蓝高亮
  modifier, // 定语从句 / 修饰成分 - 琥珀金高亮
  adverbial,// 状语 / 逻辑转折 - 翡翠绿高亮
}

class SentenceSegment {
  final String text;
  final ClauseRole role;

  const SentenceSegment(this.text, this.role);
}

class ReadingWordHint {
  final String word;
  final String phonetic;
  final String meaning;
  final String tip;

  const ReadingWordHint({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.tip,
  });
}

class ReadingSentence {
  final String en;
  final String zh;
  final List<SentenceSegment> segments;
  final String structureNote; // 一句话拆解长难句骨架

  const ReadingSentence({
    required this.en,
    required this.zh,
    required this.segments,
    required this.structureNote,
  });
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation; // 定位句 + 425分防坑技巧

  const ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class ReadingPassage {
  final String id;
  final String title;
  final String topicTag;
  final String examSource; // 如：六级仔细阅读真题精选 (14.2分/题)
  final List<ReadingSentence> sentences;
  final Map<String, ReadingWordHint> glossary;
  final List<ReadingQuestion> questions;

  const ReadingPassage({
    required this.id,
    required this.title,
    required this.topicTag,
    required this.examSource,
    required this.sentences,
    required this.glossary,
    required this.questions,
  });
}

/// 听力盲听/精听文本与同义替换词对
class SynonymTrap {
  final String audioWord; // 原文听到的词
  final String answerSynonym; // 正确答案里的同义替换
  final String meaningZh;

  const SynonymTrap({
    required this.audioWord,
    required this.answerSynonym,
    required this.meaningZh,
  });
}

class ListeningLine {
  final String speaker; // M / W / Lecturer
  final String en;
  final String zh;
  final List<String> highlightWords; // 触发同义替换高亮的原文词

  const ListeningLine({
    required this.speaker,
    required this.en,
    required this.zh,
    this.highlightWords = const [],
  });
}

class ListeningTrack {
  final String id;
  final String title;
  final String sectionType; // Section A 长对话 / Section B 短文 / Section C 讲座(14.2分/题)
  final String difficultyTag;
  final List<ListeningLine> lines;
  final List<SynonymTrap> traps;
  final List<ReadingQuestion> questions;

  const ListeningTrack({
    required this.id,
    required this.title,
    required this.sectionType,
    required this.difficultyTag,
    required this.lines,
    required this.traps,
    required this.questions,
  });
}

/// 写作三段式救命模板
class EssayBlank {
  final String key;
  final String label;
  final String placeholder;
  final String sampleFill;

  const EssayBlank({
    required this.key,
    required this.label,
    required this.placeholder,
    required this.sampleFill,
  });
}

class WritingTemplate {
  final String id;
  final String topic; // 社会现象 / 科技发展 / 传统文化 / 青年成长
  final String title;
  final String scoreStrategy;
  final List<EssayBlank> blanks;
  final String templateBody; // 使用 {{key}} 占位
  final String referenceEssay;
  final List<String> upgradeSentences; // 高分万能加分句

  const WritingTemplate({
    required this.id,
    required this.topic,
    required this.title,
    required this.scoreStrategy,
    required this.blanks,
    required this.templateBody,
    required this.referenceEssay,
    required this.upgradeSentences,
  });
}

/// 翻译高频替换词与真题演练
class TranslationTerm {
  final String zh;
  final String advancedEn; // 高分表达
  final String rescueEn; // 425救命平替（绝不留空！）
  final String category; // 传统文化 / 科技基建 / 生态环保 / 经济民生

  const TranslationTerm({
    required this.zh,
    required this.advancedEn,
    required this.rescueEn,
    required this.category,
  });
}

class TranslationDrill {
  final String id;
  final String title;
  final String category;
  final String chinesePrompt;
  final String referenceEn;
  final List<String> keyTips;

  const TranslationDrill({
    required this.id,
    required this.title,
    required this.category,
    required this.chinesePrompt,
    required this.referenceEn,
    required this.keyTips,
  });
}

/// 用户生词本条目（合并背词错题 + 阅读点击加入的生词）
class SavedWordEntry {
  final String word;
  final String phonetic;
  final String meaning;
  final String source; // 词汇卡 / 阅读精读
  final int addedAtMs;

  const SavedWordEntry({
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.source,
    required this.addedAtMs,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'phonetic': phonetic,
        'meaning': meaning,
        'source': source,
        'addedAtMs': addedAtMs,
      };

  factory SavedWordEntry.fromJson(Map<String, dynamic> json) => SavedWordEntry(
        word: (json['word'] ?? '').toString(),
        phonetic: (json['phonetic'] ?? '').toString(),
        meaning: (json['meaning'] ?? '').toString(),
        source: (json['source'] ?? '生词本').toString(),
        addedAtMs: (json['addedAtMs'] as num?)?.toInt() ?? 0,
      );
}

/// 模考分数记录
class MockScoreRecord {
  final String dateKey;
  final double totalScore;
  final double writing;
  final double translation;
  final double listening;
  final double reading;

  const MockScoreRecord({
    required this.dateKey,
    required this.totalScore,
    required this.writing,
    required this.translation,
    required this.listening,
    required this.reading,
  });

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'totalScore': totalScore,
        'writing': writing,
        'translation': translation,
        'listening': listening,
        'reading': reading,
      };

  factory MockScoreRecord.fromJson(Map<String, dynamic> json) => MockScoreRecord(
        dateKey: (json['dateKey'] ?? '').toString(),
        totalScore: (json['totalScore'] as num?)?.toDouble() ?? 0,
        writing: (json['writing'] as num?)?.toDouble() ?? 0,
        translation: (json['translation'] as num?)?.toDouble() ?? 0,
        listening: (json['listening'] as num?)?.toDouble() ?? 0,
        reading: (json['reading'] as num?)?.toDouble() ?? 0,
      );
}
