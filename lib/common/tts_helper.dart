import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {

  /// 默认语音播放速度
  static double SPEECH_RATE = 3;

  static FlutterTts _tts;

  static Completer _completionCompleter;

  /// 初始化语音播报插件
  static Future init() {
    return Future.microtask(() async {
      _tts = FlutterTts();
      _tts.setCompletionHandler(() {
        _completionCompleter?.complete();
      });
      await setSpeechRate(SPEECH_RATE);
    });
  }

  /// 播放制定文字
  static Future speak(String text) {
    _completionCompleter = Completer();
    _tts.speak(text);
    return _completionCompleter.future;
  }

  /// 停止播放语音
  static Future<dynamic> stop() {
    return _tts.stop().then((_) {
      if (_completionCompleter != null && !_completionCompleter.isCompleted) {
        _completionCompleter.complete();
      }
    });
  }

  /// 判断是否正在播放语音
  static bool isPlaying() {
    return _completionCompleter?.isCompleted ?? false;
  }

  /// 设置语音播放速度
  static Future<dynamic> setSpeechRate(double rate) {
    if (_tts == null) {
      return null;
    }
    return _tts.setSpeechRate(rate);
  }
}