import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/study_models.dart';

/// 每日三件小事进度快照
class DailyTaskSnapshot {
  final String dateKey;
  final int vocabDoneCount; // 目标 20 个高频词
  final bool readingDone; // 目标 1 篇真题精读
  final bool listeningDone; // 目标 1 段精听磨耳朵
  final bool celebratedToday; // 今日是否已触发完成庆祝动画

  const DailyTaskSnapshot({
    required this.dateKey,
    this.vocabDoneCount = 0,
    this.readingDone = false,
    this.listeningDone = false,
    this.celebratedToday = false,
  });

  bool get vocabDone => vocabDoneCount >= 20;
  int get completedCount =>
      (vocabDone ? 1 : 0) + (readingDone ? 1 : 0) + (listeningDone ? 1 : 0);
  bool get allCompleted => completedCount == 3;

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'vocabDoneCount': vocabDoneCount,
        'readingDone': readingDone,
        'listeningDone': listeningDone,
        'celebratedToday': celebratedToday,
      };

  factory DailyTaskSnapshot.fromJson(Map<String, dynamic> json, String fallbackDate) =>
      DailyTaskSnapshot(
        dateKey: (json['dateKey'] ?? fallbackDate).toString(),
        vocabDoneCount: (json['vocabDoneCount'] as num?)?.toInt() ?? 0,
        readingDone: json['readingDone'] == true,
        listeningDone: json['listeningDone'] == true,
        celebratedToday: json['celebratedToday'] == true,
      );
}

/// 成就徽章模型
class StudyBadge {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final bool unlocked;

  const StudyBadge({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.unlocked,
  });
}

/// 全离线本地持久化服务（背词艾宾浩斯进度、生词本、热力图打卡、模考算分、写作草稿）
class StudyStorageService {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static const _kVocabProgress = 'cet6_vocab_ebbinghaus_v1';
  static const _kSavedWords = 'cet6_saved_wordbook_v1';
  static const _kDailyTask = 'cet6_daily_task_v1';
  static const _kHeatmap = 'cet6_checkin_heatmap_v1';
  static const _kMockScores = 'cet6_mock_scores_v1';
  static const _kScoreSim = 'cet6_score_simulator_v1';
  static const _kWritingDrafts = 'cet6_writing_drafts_v1';
  static const _kCompletedReadings = 'cet6_completed_readings_v1';
  static const _kCompletedListenings = 'cet6_completed_listenings_v1';
  static const _kDarkMode = 'cet6_dark_mode_v1';

  /// 艾宾浩斯记忆间隔（小时）：0.1h(6分钟) -> 12h -> 24h -> 48h -> 96h -> 168h -> 360h
  static const List<int> ebbinghausHours = [0, 12, 24, 48, 96, 168, 360];

  static const List<String> healingQuotes = [
    '四级425压线又怎样？你已经比昨天的自己多掌握了拿分底牌，2027年6月稳过450+！',
    '背完这20个真题高频词，你就已经甩开了一半还在背“abandon”的考友！',
    '六级从不是天才的考试，而是每天完成3件小事的长期主义者的胜利。',
    '今天又点亮了一颗克莱因蓝打卡格子！每一天的微小积累，都在替你托底450分。',
    '战略放弃3.55分的选词填空，死磕14.2分的仔细阅读，聪明努力的人必上岸！',
    '你不需要背完5000词，把最常考的高频救命词刷透，考场照样降维打击！',
  ];

  static String randomHealingQuote() {
    return healingQuotes[Random().nextInt(healingQuotes.length)];
  }

  static String todayKey([DateTime? dt]) {
    final d = dt ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static void _notify() => version.value++;

  // ==================== 主题记忆 ====================
  static Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kDarkMode) ?? false; // 默认护眼浅米白模式
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kDarkMode, isDark);
  }

  // ==================== 艾宾浩斯词汇进度 ====================
  static Future<Map<String, EbbinghausProgress>> loadVocabProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kVocabProgress);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (k, v) => MapEntry(k, EbbinghausProgress.fromJson(v as Map<String, dynamic>)),
      );
    } catch (_) {
      return {};
    }
  }

  /// 记录一次划卡：known=true 右滑秒杀（进入艾宾浩斯曲线），known=false 左滑重学
  static Future<bool> recordWordSwipe(VocabWord word, {required bool known}) async {
    final prefs = await SharedPreferences.getInstance();
    final map = await loadVocabProgress();
    final prev = map[word.id] ??
        EbbinghausProgress(wordId: word.id, stage: 0, nextReviewMs: 0, wrongCount: 0);

    final now = DateTime.now().millisecondsSinceEpoch;
    late EbbinghausProgress next;
    if (known) {
      final newStage = (prev.stage + 1).clamp(1, ebbinghausHours.length - 1);
      final waitMs = ebbinghausHours[newStage] * 3600 * 1000;
      next = EbbinghausProgress(
        wordId: word.id,
        stage: newStage,
        nextReviewMs: now + waitMs,
        wrongCount: prev.wrongCount,
      );
    } else {
      next = EbbinghausProgress(
        wordId: word.id,
        stage: 0,
        nextReviewMs: now + 5 * 60 * 1000,
        wrongCount: prev.wrongCount + 1,
      );
      await addSavedWord(
        SavedWordEntry(
          word: word.word,
          phonetic: word.phonetic,
          meaning: word.coreMeaning,
          source: '高频词错题',
          addedAtMs: now,
        ),
        silent: true,
      );
    }

    map[word.id] = next;
    await prefs.setString(
      _kVocabProgress,
      jsonEncode(map.map((k, v) => MapEntry(k, v.toJson()))),
    );

    // 累加今日背词进度 + 热力图能量
    final task = await loadDailyTask();
    final updated = DailyTaskSnapshot(
      dateKey: task.dateKey,
      vocabDoneCount: task.vocabDoneCount + 1,
      readingDone: task.readingDone,
      listeningDone: task.listeningDone,
      celebratedToday: task.celebratedToday,
    );
    await _saveDailyTask(updated);
    await incrementTodayHeatmap(1);
    _notify();
    return updated.allCompleted && !updated.celebratedToday;
  }

  // ==================== 生词本 / 错题本 ====================
  static Future<List<SavedWordEntry>> loadSavedWords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSavedWords);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SavedWordEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addSavedWord(SavedWordEntry entry, {bool silent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadSavedWords();
    list.removeWhere((e) => e.word.toLowerCase() == entry.word.toLowerCase());
    list.insert(0, entry);
    await prefs.setString(
      _kSavedWords,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    if (!silent) _notify();
  }

  static Future<void> removeSavedWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadSavedWords();
    list.removeWhere((e) => e.word.toLowerCase() == word.toLowerCase());
    await prefs.setString(
      _kSavedWords,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    _notify();
  }

  // ==================== 今日仅需完成的 3 件小事 ====================
  static Future<DailyTaskSnapshot> loadDailyTask() async {
    final prefs = await SharedPreferences.getInstance();
    final today = todayKey();
    final raw = prefs.getString(_kDailyTask);
    if (raw == null || raw.isEmpty) {
      return DailyTaskSnapshot(dateKey: today);
    }
    try {
      final snap = DailyTaskSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>, today);
      if (snap.dateKey != today) {
        return DailyTaskSnapshot(dateKey: today);
      }
      return snap;
    } catch (_) {
      return DailyTaskSnapshot(dateKey: today);
    }
  }

  static Future<void> _saveDailyTask(DailyTaskSnapshot snap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kDailyTask, jsonEncode(snap.toJson()));
  }

  static Future<bool> markReadingTaskDone(String passageId) async {
    final prefs = await SharedPreferences.getInstance();
    final doneIds = Set<String>.from(prefs.getStringList(_kCompletedReadings) ?? []);
    doneIds.add(passageId);
    await prefs.setStringList(_kCompletedReadings, doneIds.toList());

    final task = await loadDailyTask();
    final updated = DailyTaskSnapshot(
      dateKey: task.dateKey,
      vocabDoneCount: task.vocabDoneCount,
      readingDone: true,
      listeningDone: task.listeningDone,
      celebratedToday: task.celebratedToday,
    );
    await _saveDailyTask(updated);
    await incrementTodayHeatmap(2);
    _notify();
    return updated.allCompleted && !updated.celebratedToday;
  }

  static Future<bool> markListeningTaskDone(String trackId) async {
    final prefs = await SharedPreferences.getInstance();
    final doneIds = Set<String>.from(prefs.getStringList(_kCompletedListenings) ?? []);
    doneIds.add(trackId);
    await prefs.setStringList(_kCompletedListenings, doneIds.toList());

    final task = await loadDailyTask();
    final updated = DailyTaskSnapshot(
      dateKey: task.dateKey,
      vocabDoneCount: task.vocabDoneCount,
      readingDone: task.readingDone,
      listeningDone: true,
      celebratedToday: task.celebratedToday,
    );
    await _saveDailyTask(updated);
    await incrementTodayHeatmap(2);
    _notify();
    return updated.allCompleted && !updated.celebratedToday;
  }

  static Future<void> markTodayCelebrated() async {
    final task = await loadDailyTask();
    await _saveDailyTask(DailyTaskSnapshot(
      dateKey: task.dateKey,
      vocabDoneCount: task.vocabDoneCount,
      readingDone: task.readingDone,
      listeningDone: task.listeningDone,
      celebratedToday: true,
    ));
    _notify();
  }

  static Future<Set<String>> loadCompletedReadings() async {
    final prefs = await SharedPreferences.getInstance();
    return Set<String>.from(prefs.getStringList(_kCompletedReadings) ?? []);
  }

  static Future<Set<String>> loadCompletedListenings() async {
    final prefs = await SharedPreferences.getInstance();
    return Set<String>.from(prefs.getStringList(_kCompletedListenings) ?? []);
  }

  // ==================== GitHub 风格学习热力图 & 连续打卡天数 ====================
  static Future<Map<String, int>> loadHeatmap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kHeatmap);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as num).toInt()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> incrementTodayHeatmap(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final map = await loadHeatmap();
    final key = todayKey();
    map[key] = (map[key] ?? 0) + points;
    await prefs.setString(_kHeatmap, jsonEncode(map));
  }

  static int computeStreakDays(Map<String, int> heatmap) {
    int streak = 0;
    DateTime cursor = DateTime.now();
    // 如果今天尚未打卡，从昨天开始算连续天数，避免当天清零焦虑
    if ((heatmap[todayKey(cursor)] ?? 0) == 0) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while ((heatmap[todayKey(cursor)] ?? 0) > 0) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static Future<List<StudyBadge>> computeBadges() async {
    final heatmap = await loadHeatmap();
    final vocabMap = await loadVocabProgress();
    final readings = await loadCompletedReadings();
    final listenings = await loadCompletedListenings();
    final mockScores = await loadMockScores();
    final streak = computeStreakDays(heatmap);
    final mastered = vocabMap.values.where((v) => v.stage >= 1).length;
    final has450 = mockScores.any((m) => m.totalScore >= 450);

    return [
      StudyBadge(
        id: 'first_day',
        title: '破冰启航',
        subtitle: '完成首日备考打卡',
        emoji: '🚀',
        unlocked: heatmap.isNotEmpty,
      ),
      StudyBadge(
        id: 'streak_3',
        title: '三日连击',
        subtitle: '连续打卡满 3 天',
        emoji: '🔥',
        unlocked: streak >= 3,
      ),
      StudyBadge(
        id: 'vocab_30',
        title: '救命词斩将',
        subtitle: '攻克 30+ 高频救命词',
        emoji: '⚡',
        unlocked: mastered >= 30,
      ),
      StudyBadge(
        id: 'reading_pro',
        title: '长难句解剖师',
        subtitle: '精读至少 1 篇真题',
        emoji: '📖',
        unlocked: readings.isNotEmpty,
      ),
      StudyBadge(
        id: 'listening_pro',
        title: '磨耳朵达人',
        subtitle: '完成至少 1 段精听',
        emoji: '🎧',
        unlocked: listenings.isNotEmpty,
      ),
      StudyBadge(
        id: 'pass_450',
        title: '450+稳过预备役',
        subtitle: '模考测算突破 450 分',
        emoji: '🏆',
        unlocked: has450,
      ),
    ];
  }

  // ==================== 425 -> 450+ 算分器 & 模考记录 ====================
  static Future<Map<String, double>> loadScoreSimulator() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kScoreSim);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
      } catch (_) {}
    }
    // 默认给出「425压线稳过460分」黄金配分方案
    return {
      'writing': 72.0,     // 满分106.5，模板套好稳拿72+
      'translation': 70.0, // 满分106.5，平替词写满稳拿70+
      'listenAB': 9.0,     // Section A+B 共15题×7.1，对9题=63.9
      'listenC': 5.0,      // Section C 讲座10题×14.2，对5题=71.0
      'carefulRead': 7.0,  // 仔细阅读10题×14.2，重点猛攻对7题=99.4
      'matchRead': 8.0,    // 长篇匹配10题×7.1，找关键词对8题=56.8
      'bankedCloze': 3.0,  // 选词填空10题×3.55，战略放弃蒙3题=10.65
    };
  }

  static Future<void> saveScoreSimulator(Map<String, double> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kScoreSim, jsonEncode(values));
  }

  static Future<List<MockScoreRecord>> loadMockScores() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kMockScores);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MockScoreRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> addMockScore(MockScoreRecord rec) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadMockScores();
    list.insert(0, rec);
    if (list.length > 20) list.removeLast();
    await prefs.setString(
      _kMockScores,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    await incrementTodayHeatmap(1);
    _notify();
  }

  // ==================== 写作填空草稿本地保存 ====================
  static Future<Map<String, String>> loadWritingDraft(String templateId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('${_kWritingDrafts}_$templateId');
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> saveWritingDraft(
      String templateId, Map<String, String> fills) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_kWritingDrafts}_$templateId', jsonEncode(fills));
    await incrementTodayHeatmap(1);
    _notify();
  }
}
