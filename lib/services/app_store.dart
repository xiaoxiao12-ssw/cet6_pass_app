import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cet6_models.dart';

/// 全局本地持久化状态中心（基于 shared_preferences，全离线）
class AppStore extends ChangeNotifier {
  static final AppStore instance = AppStore._();
  AppStore._();

  static const _kVocabProgress = 'cet6_v2_vocab_progress';
  static const _kWordbookIds = 'cet6_v2_wordbook_ids';
  static const _kCustomVocab = 'cet6_v2_custom_vocab';
  static const _kTodayStudyDate = 'cet6_v2_today_study_date';
  static const _kTodayStudiedIds = 'cet6_v2_today_studied_ids';
  static const _kDailyGoal = 'cet6_v2_daily_goal';
  static const _kCheckedInDates = 'cet6_v2_checked_in_dates';
  static const _kListeningRecords = 'cet6_v2_listening_records';
  static const _kReadingRecords = 'cet6_v2_reading_records';
  static const _kWritingDrafts = 'cet6_v2_writing_drafts';
  static const _kTranslationDrafts = 'cet6_v2_translation_drafts';

  /// 2027 年 6 月英语六级考试（6月第三个周六：2027-06-19）
  static final DateTime cet6ExamDate = DateTime(2027, 6, 19);

  SharedPreferences? _prefs;
  bool _loaded = false;

  List<VocabItem> _builtinVocab = [];
  List<VocabItem> _customVocab = [];
  final Map<String, VocabItem> _wordIndex = {};

  final Map<String, VocabProgress> _vocabProgress = {};
  final Set<String> _wordbookIds = {};
  final Set<String> _todayStudiedIds = {};
  final Set<String> _checkedInDates = {};
  int _dailyGoal = 20;

  final Map<String, ListeningRecord> _listeningRecords = {};
  final Map<String, ReadingRecord> _readingRecords = {};
  final Map<String, String> _writingDrafts = {};
  final Map<String, String> _translationDrafts = {};

  bool get isLoaded => _loaded;
  List<VocabItem> get allVocab => [..._builtinVocab, ..._customVocab];
  List<VocabItem> get customVocab => List.unmodifiable(_customVocab);
  Set<String> get wordbookIds => Set.unmodifiable(_wordbookIds);
  int get dailyGoal => _dailyGoal;
  int get todayStudiedCount => _todayStudiedIds.length;
  int get totalCheckedInDays => _checkedInDates.length;
  bool get isCheckedInToday => _checkedInDates.contains(todayKey);

  int get daysUntilExam {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = cet6ExamDate.difference(today).inDays;
    return diff > 0 ? diff : 0;
  }

  static String get todayKey {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }

  static int get todayEpochDay {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }

  Future<void> init() async {
    if (_loaded) return;
    _prefs = await SharedPreferences.getInstance();

    // 1. 加载内置六级核心高频词库 JSON
    try {
      final raw = await rootBundle.loadString('assets/data/cet6_vocab.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _builtinVocab = decoded
          .whereType<Map<String, dynamic>>()
          .map((e) => VocabItem.fromJson(e))
          .toList();
    } catch (_) {
      _builtinVocab = [];
    }

    // 2. 加载用户本地扩展 JSON 词条
    final customRaw = _prefs?.getString(_kCustomVocab);
    if (customRaw != null && customRaw.isNotEmpty) {
      try {
        final list = jsonDecode(customRaw) as List<dynamic>;
        _customVocab = list
            .whereType<Map<String, dynamic>>()
            .map((e) => VocabItem.fromJson(e, custom: true))
            .toList();
      } catch (_) {}
    }

    _rebuildWordIndex();

    // 3. 加载背词艾宾浩斯进度
    final progRaw = _prefs?.getString(_kVocabProgress);
    if (progRaw != null && progRaw.isNotEmpty) {
      try {
        final map = jsonDecode(progRaw) as Map<String, dynamic>;
        map.forEach((k, v) {
          if (v is Map<String, dynamic>) {
            _vocabProgress[k] = VocabProgress.fromJson(v);
          }
        });
      } catch (_) {}
    }

    // 4. 生词本
    final wbList = _prefs?.getStringList(_kWordbookIds) ?? [];
    _wordbookIds.addAll(wbList);

    // 5. 今日学习记录（跨日自动重置）
    _dailyGoal = _prefs?.getInt(_kDailyGoal) ?? 20;
    final savedDate = _prefs?.getString(_kTodayStudyDate);
    if (savedDate == todayKey) {
      _todayStudiedIds.addAll(_prefs?.getStringList(_kTodayStudiedIds) ?? []);
    } else {
      await _prefs?.setString(_kTodayStudyDate, todayKey);
      await _prefs?.setStringList(_kTodayStudiedIds, []);
    }

    // 6. 打卡记录
    _checkedInDates.addAll(_prefs?.getStringList(_kCheckedInDates) ?? []);

    // 7. 听力做题记录
    final lRaw = _prefs?.getString(_kListeningRecords);
    if (lRaw != null && lRaw.isNotEmpty) {
      try {
        final map = jsonDecode(lRaw) as Map<String, dynamic>;
        map.forEach((k, v) {
          if (v is Map<String, dynamic>) {
            _listeningRecords[k] = ListeningRecord.fromJson(v);
          }
        });
      } catch (_) {}
    }

    // 8. 阅读做题记录
    final rRaw = _prefs?.getString(_kReadingRecords);
    if (rRaw != null && rRaw.isNotEmpty) {
      try {
        final map = jsonDecode(rRaw) as Map<String, dynamic>;
        map.forEach((k, v) {
          if (v is Map<String, dynamic>) {
            _readingRecords[k] = ReadingRecord.fromJson(v);
          }
        });
      } catch (_) {}
    }

    // 9. 写作与翻译草稿
    final wRaw = _prefs?.getString(_kWritingDrafts);
    if (wRaw != null && wRaw.isNotEmpty) {
      try {
        final map = jsonDecode(wRaw) as Map<String, dynamic>;
        map.forEach((k, v) => _writingDrafts[k] = v.toString());
      } catch (_) {}
    }

    final tRaw = _prefs?.getString(_kTranslationDrafts);
    if (tRaw != null && tRaw.isNotEmpty) {
      try {
        final map = jsonDecode(tRaw) as Map<String, dynamic>;
        map.forEach((k, v) => _translationDrafts[k] = v.toString());
      } catch (_) {}
    }

    _loaded = true;
    notifyListeners();
  }

  void _rebuildWordIndex() {
    _wordIndex.clear();
    for (final item in allVocab) {
      _wordIndex[item.word.toLowerCase()] = item;
    }
  }

  // ==================== 查词与词形还原（供 Tab 3 阅读点词查词） ====================

  VocabItem? lookupWord(String rawToken) {
    final clean = rawToken.toLowerCase().replaceAll(RegExp(r"[^a-z]"), '');
    if (clean.length < 4) return null;

    if (_wordIndex.containsKey(clean)) return _wordIndex[clean];

    // 常见英文屈折变化还原匹配六级词库原型
    final candidates = <String>[];
    if (clean.endsWith('ies') && clean.length > 4) {
      candidates.add('${clean.substring(0, clean.length - 3)}y');
    }
    if (clean.endsWith('es') && clean.length > 4) {
      candidates.add(clean.substring(0, clean.length - 2));
    }
    if (clean.endsWith('s') && clean.length > 4) {
      candidates.add(clean.substring(0, clean.length - 1));
    }
    if (clean.endsWith('ied') && clean.length > 4) {
      candidates.add('${clean.substring(0, clean.length - 3)}y');
    }
    if (clean.endsWith('ed') && clean.length > 4) {
      candidates.add(clean.substring(0, clean.length - 2));
      candidates.add(clean.substring(0, clean.length - 1));
    }
    if (clean.endsWith('ing') && clean.length > 5) {
      final stem = clean.substring(0, clean.length - 3);
      candidates.add(stem);
      candidates.add('${stem}e');
      if (stem.length >= 2 && stem[stem.length - 1] == stem[stem.length - 2]) {
        candidates.add(stem.substring(0, stem.length - 1));
      }
    }
    if (clean.endsWith('ly') && clean.length > 5) {
      candidates.add(clean.substring(0, clean.length - 2));
      if (clean.endsWith('ily')) {
        candidates.add('${clean.substring(0, clean.length - 3)}y');
      }
    }

    for (final c in candidates) {
      if (_wordIndex.containsKey(c)) return _wordIndex[c];
    }
    return null;
  }

  // ==================== Tab 1 背词：艾宾浩斯进度、生词本、JSON 扩展 ====================

  VocabProgress? getVocabProgress(String wordId) => _vocabProgress[wordId];

  bool isInWordbook(String wordId) => _wordbookIds.contains(wordId);

  int get masteredCount =>
      _vocabProgress.values.where((p) => p.isMastered).length;

  int get dueReviewCount {
    final today = todayEpochDay;
    return _vocabProgress.values
        .where((p) => p.stage >= 1 && p.nextReviewEpochDay <= today)
        .length;
  }

  int get relearnTodayCount =>
      _vocabProgress.values.where((p) => p.stage == 0 && p.wrongCount > 0).length;

  /// 构建当前背词队列：优先今日重学 -> 艾宾浩斯到期复习 -> 未学新词
  List<VocabItem> buildVocabQueue({required bool wordbookOnly}) {
    final source = wordbookOnly
        ? allVocab.where((w) => _wordbookIds.contains(w.id)).toList()
        : allVocab;

    final today = todayEpochDay;
    final relearn = <VocabItem>[];
    final dueReview = <VocabItem>[];
    final fresh = <VocabItem>[];
    final scheduledLater = <VocabItem>[];

    for (final item in source) {
      final p = _vocabProgress[item.id];
      if (p == null) {
        fresh.add(item);
      } else if (p.stage == 0) {
        relearn.add(item);
      } else if (p.nextReviewEpochDay <= today) {
        dueReview.add(item);
      } else {
        scheduledLater.add(item);
      }
    }

    final result = [...relearn, ...dueReview, ...fresh];
    if (result.isEmpty && wordbookOnly) {
      return scheduledLater;
    }
    return result;
  }

  Future<void> markVocabUnknown(String wordId) async {
    final prev = _vocabProgress[wordId];
    _vocabProgress[wordId] = VocabProgress(
      stage: 0,
      nextReviewEpochDay: todayEpochDay,
      wrongCount: (prev?.wrongCount ?? 0) + 1,
      lastStudiedDate: todayKey,
    );
    _recordTodayStudy(wordId);
    await _saveVocabState();
    notifyListeners();
  }

  Future<int> markVocabMastered(String wordId) async {
    final prev = _vocabProgress[wordId];
    final nextStage = ((prev?.stage ?? 0) + 1)
        .clamp(1, VocabProgress.ebbinghausIntervals.length - 1);
    final intervalDays = VocabProgress.ebbinghausIntervals[nextStage];

    _vocabProgress[wordId] = VocabProgress(
      stage: nextStage,
      nextReviewEpochDay: todayEpochDay + intervalDays,
      wrongCount: prev?.wrongCount ?? 0,
      lastStudiedDate: todayKey,
    );
    _recordTodayStudy(wordId);
    await _saveVocabState();
    notifyListeners();
    return intervalDays;
  }

  void _recordTodayStudy(String wordId) {
    _todayStudiedIds.add(wordId);
    if (_todayStudiedIds.length >= 5) {
      _checkedInDates.add(todayKey);
    }
  }

  Future<void> toggleWordbook(String wordId) async {
    if (_wordbookIds.contains(wordId)) {
      _wordbookIds.remove(wordId);
    } else {
      _wordbookIds.add(wordId);
    }
    await _prefs?.setStringList(_kWordbookIds, _wordbookIds.toList());
    notifyListeners();
  }

  Future<void> addToWordbook(String wordId) async {
    if (_wordbookIds.add(wordId)) {
      await _prefs?.setStringList(_kWordbookIds, _wordbookIds.toList());
      notifyListeners();
    }
  }

  Future<String?> importCustomVocabJson(String rawJson) async {
    try {
      final decoded = jsonDecode(rawJson);
      final List<dynamic> list;
      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map && decoded['words'] is List) {
        list = decoded['words'] as List<dynamic>;
      } else {
        return 'JSON 格式需为词条数组 [...] 或包含 words 数组的对象';
      }

      int added = 0;
      for (final entry in list) {
        if (entry is! Map<String, dynamic>) continue;
        final wordText = (entry['word'] ?? '').toString().trim();
        if (wordText.isEmpty) continue;
        if (_wordIndex.containsKey(wordText.toLowerCase())) continue;

        final item = VocabItem.fromJson(entry, custom: true);
        _customVocab.add(item);
        _wordIndex[item.word.toLowerCase()] = item;
        added++;
      }

      if (added == 0) {
        return '未导入新词条（可能词条已存在于词库中或缺少 word 字段）';
      }

      await _prefs?.setString(
        _kCustomVocab,
        jsonEncode(_customVocab.map((e) => e.toJson()).toList()),
      );
      notifyListeners();
      return null; // null 表示成功
    } catch (e) {
      return 'JSON 解析失败：请检查括号与引号格式';
    }
  }

  Future<void> _saveVocabState() async {
    final map = _vocabProgress.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs?.setString(_kVocabProgress, jsonEncode(map));
    await _prefs?.setString(_kTodayStudyDate, todayKey);
    await _prefs?.setStringList(_kTodayStudiedIds, _todayStudiedIds.toList());
    await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
  }

  Future<void> checkInToday() async {
    if (_checkedInDates.add(todayKey)) {
      await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
      notifyListeners();
    }
  }

  // ==================== Tab 2 听力记录持久化 ====================

  ListeningRecord? getListeningRecord(String exerciseId) =>
      _listeningRecords[exerciseId];

  int get totalListeningWrongCount => _listeningRecords.values
      .fold(0, (sum, r) => sum + r.wrongQuestionNumbers.length);

  Future<void> saveListeningRecord(
    String exerciseId,
    ListeningRecord record,
  ) async {
    _listeningRecords[exerciseId] = record;
    _checkedInDates.add(todayKey);
    await _prefs?.setString(
      _kListeningRecords,
      jsonEncode(_listeningRecords.map((k, v) => MapEntry(k, v.toJson()))),
    );
    await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
    notifyListeners();
  }

  // ==================== Tab 3 阅读记录持久化 ====================

  ReadingRecord? getReadingRecord(String exerciseId) =>
      _readingRecords[exerciseId];

  int get totalReadingWrongCount => _readingRecords.values
      .fold(0, (sum, r) => sum + r.wrongNumbers.length);

  Future<void> saveReadingRecord(
    String exerciseId,
    ReadingRecord record,
  ) async {
    _readingRecords[exerciseId] = record;
    _checkedInDates.add(todayKey);
    await _prefs?.setString(
      _kReadingRecords,
      jsonEncode(_readingRecords.map((k, v) => MapEntry(k, v.toJson()))),
    );
    await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
    notifyListeners();
  }

  // ==================== Tab 4 写译草稿持久化 ====================

  String getWritingDraft(String topicId) => _writingDrafts[topicId] ?? '';

  Future<void> saveWritingDraft(String topicId, String text) async {
    _writingDrafts[topicId] = text;
    if (text.trim().length >= 30) {
      _checkedInDates.add(todayKey);
      await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
    }
    await _prefs?.setString(_kWritingDrafts, jsonEncode(_writingDrafts));
    notifyListeners();
  }

  String getTranslationDraft(String topicId) =>
      _translationDrafts[topicId] ?? '';

  Future<void> saveTranslationDraft(String topicId, String text) async {
    _translationDrafts[topicId] = text;
    if (text.trim().length >= 20) {
      _checkedInDates.add(todayKey);
      await _prefs?.setStringList(_kCheckedInDates, _checkedInDates.toList());
    }
    await _prefs?.setString(
      _kTranslationDrafts,
      jsonEncode(_translationDrafts),
    );
    notifyListeners();
  }
}
