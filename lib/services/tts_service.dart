import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// 本地离线英语 TTS 朗读引擎
/// 支持单词/例句朗读及听力逐句连播，支持 0.8x / 1.0x / 1.2x 语速调节
class TtsService {
  static final TtsService instance = TtsService._();
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  double _speed = 1.0;
  int _sessionToken = 0;

  List<String> _queue = [];
  int _queueIndex = -1;
  bool _isQueuePlaying = false;
  ValueChanged<int>? _onSentenceStart;
  VoidCallback? _onQueueDone;

  double get speed => _speed;
  bool get isQueuePlaying => _isQueuePlaying;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _applyRate(_speed);

      _tts.setCompletionHandler(() {
        _handleSentenceCompleted(_sessionToken);
      });
      _tts.setErrorHandler((_) {
        _handleSentenceCompleted(_sessionToken);
      });
      _initialized = true;
    } catch (_) {
      // 无离线语音引擎或模拟器环境安全兜底
    }
  }

  /// 将显示倍速 (0.8x / 1.0x / 1.2x) 映射为 Android TTS 语速参数
  Future<void> _applyRate(double speed) async {
    double rate = 0.50;
    if (speed <= 0.85) {
      rate = 0.38;
    } else if (speed >= 1.15) {
      rate = 0.62;
    }
    try {
      await _tts.setSpeechRate(rate);
    } catch (_) {}
  }

  Future<void> setSpeed(double speed) async {
    _speed = speed;
    await init();
    await _applyRate(speed);
  }

  /// 朗读单个单词或单句英语
  Future<void> speakText(String text, {double? speed}) async {
    await init();
    _sessionToken++;
    _isQueuePlaying = false;
    _queue = [];
    _queueIndex = -1;
    _onSentenceStart = null;
    _onQueueDone = null;

    try {
      await _tts.stop();
      await _applyRate(speed ?? _speed);
      await _tts.speak(text);
    } catch (_) {}
  }

  /// 逐句顺序连播听力文本
  Future<void> playQueue(
    List<String> texts, {
    int startIndex = 0,
    double? speed,
    ValueChanged<int>? onSentenceStart,
    VoidCallback? onQueueDone,
  }) async {
    if (texts.isEmpty) return;
    await init();

    final token = ++_sessionToken;
    _queue = List<String>.from(texts);
    _queueIndex = startIndex.clamp(0, _queue.length - 1);
    _isQueuePlaying = true;
    _onSentenceStart = onSentenceStart;
    _onQueueDone = onQueueDone;

    if (speed != null) {
      _speed = speed;
    }

    try {
      await _tts.stop();
      await _applyRate(_speed);
      if (token != _sessionToken) return;
      _onSentenceStart?.call(_queueIndex);
      await _tts.speak(_queue[_queueIndex]);
    } catch (_) {
      if (token == _sessionToken) {
        _isQueuePlaying = false;
        _onQueueDone?.call();
      }
    }
  }

  Future<void> _handleSentenceCompleted(int token) async {
    if (token != _sessionToken || !_isQueuePlaying) return;

    final nextIndex = _queueIndex + 1;
    if (nextIndex >= _queue.length) {
      _isQueuePlaying = false;
      _queueIndex = -1;
      final done = _onQueueDone;
      _onSentenceStart = null;
      _onQueueDone = null;
      done?.call();
      return;
    }

    // 句间短暂自然停顿，贴近真实六级听力节奏
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (token != _sessionToken || !_isQueuePlaying) return;

    _queueIndex = nextIndex;
    _onSentenceStart?.call(_queueIndex);
    try {
      await _applyRate(_speed);
      await _tts.speak(_queue[_queueIndex]);
    } catch (_) {
      if (token == _sessionToken) {
        _isQueuePlaying = false;
        _onQueueDone?.call();
      }
    }
  }

  Future<void> stop() async {
    _sessionToken++;
    _isQueuePlaying = false;
    _queue = [];
    _queueIndex = -1;
    _onSentenceStart = null;
    _onQueueDone = null;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
