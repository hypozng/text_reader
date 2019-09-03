import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  static FlutterTts _tts;

  static Completer _completionCompleter;

  /// 初始化语音播报插件
  static Future init() {
    return Future.microtask(() {
      _tts = FlutterTts();
      _tts.setSpeechRate(1.2);
      _tts.setCompletionHandler(() {
        _completionCompleter?.complete();
      });
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
}