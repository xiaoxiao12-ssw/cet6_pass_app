import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// 本地离线英语语音朗读引擎（封装 flutter_tts，支持词汇发音与 0.75x/1.0x/1.25x 听力精听）
class TtsService {
  static final TtsService instance = TtsService._();
  TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  double _currentSpeed = 1.0;
  VoidCallback? _onComplete;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _applyRate(_currentSpeed);
      _tts.setCompletionHandler(() {
        final cb = _onComplete;
        if (cb != null) cb();
      });
      _tts.setErrorHandler((_) {
        final cb = _onComplete;
        if (cb != null) cb();
      });
      _initialized = true;
    } catch (_) {
      // 部分模拟器或无语音包设备兜底，不崩溃
    }
  }

  /// 将显示倍速 (0.75x / 1.0x / 1.25x) 映射为 Android TTS 自然语速
  Future<void> _applyRate(double speed) async {
    double rate = 0.48;
    if (speed <= 0.8) {
      rate = 0.36;
    } else if (speed >= 1.2) {
      rate = 0.60;
    }
    try {
      await _tts.setSpeechRate(rate);
    } catch (_) {}
  }

  Future<void> setSpeed(double speed) async {
    _currentSpeed = speed;
    await init();
    await _applyRate(speed);
  }

  Future<void> speak(
    String text, {
    double? speed,
    VoidCallback? onComplete,
  }) async {
    await init();
    _onComplete = onComplete;
    try {
      await _tts.stop();
      if (speed != null) {
        await _applyRate(speed);
      }
      await _tts.speak(text);
    } catch (_) {
      if (onComplete != null) onComplete();
    }
  }

  Future<void> stop() async {
    _onComplete = null;
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
