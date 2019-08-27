import 'package:tts/tts.dart';

import 'dart:async';
import 'dart:io';

class TtsHelper {
  static const _languageMap = const <String, String>{
    'en': "en-US",
    'zh': "zh-CN",
    "ar": "ar-SA",
    "cs": "cs-CZ",
    "da": "da-DK",
    "de": "de-DE",
    "el": "el-GR",
    "es": "es-ES",
    "fi": "fi-FI",
    "fr": "fr-CA",
    "he": "he-IL",
    "hi": "hi-IN",
    "hu": "hu-HU",
    "id": "id-ID",
    "it": "it-IT",
    "ja": "ja-JP",
    "ko": "ko-KR",
    "nl": "nl-BE",
    "no": "no-NO",
    "pl": "pl-PL",
    "pt": "pt-BR",
    "ro": "ro-RO",
    "ru": "ru-RU",
    "sk": "sk-SK",
    "sv": "sv-SE",
    "th": "th-TH",
    "tr": "tr-TR",
    'en-US': "en-US",
    'zh-CN': "zh-CN",
    "ar-SA": "ar-SA",
    "cs-CZ": "cs-CZ",
    "da-DK": "da-DK",
    "de-DE": "de-DE",
    "el-GR": "el-GR",
    "es-ES": "es-ES",
    "fi-FI": "fi-FI",
    "fr-CA": "fr-CA",
    "he-IL": "he-IL",
    "hi-IN": "hi-IN",
    "hu-HU": "hu-HU",
    "id-ID": "id-ID",
    "it-IT": "it-IT",
    "ja-JP": "ja-JP",
    "ko-KR": "ko-KR",
    "nl-BE": "nl-BE",
    "no-NO": "no-NO",
    "pl-PL": "pl-PL",
    "pt-BR": "pt-BR",
    "ro-RO": "ro-RO",
    "ru-RU": "ru-RU",
    "sk-SK": "sk-SK",
    "sv-SE": "sv-SE",
    "th-TH": "th-TH",
    "tr-TR": "tr-TR",
  };

  static final String _defaultLanguage = 'en-US';

  List<String> _languages;

  static TtsHelper _instance;

  static TtsHelper get instance => _getInstance();

  factory TtsHelper() => _getInstance();

  static TtsHelper _getInstance() {
    if (_instance == null) {
      _instance = TtsHelper._internal();
    }
    return _instance;
  }

  TtsHelper._internal() {
    _initPlatformState();
  }

  void _initPlatformState() async {
    _languages = await Tts.getAvailableLanguages();
    if (_languages == null) {
      _languages = [_defaultLanguage];
    }
    _setLanguage(_defaultLanguage);
  }

  String _getTtsLanguage(String localStr) {
    if (localStr == null || localStr.isEmpty
      ||_languageMap.containsKey(localStr)) {
      return _defaultLanguage;
    }
    return _languageMap[localStr];
  }

  Future<bool> _setLanguage(String lang) async {
    String language = _getTtsLanguage(lang);
    if (language == null || language.isEmpty) {
      language = _defaultLanguage;
    }
    if (Platform.isIOS && !_languages.contains(language)) {
      return false;
    }
    return await Tts.setLanguage(language);
  }

  Future<bool> _isLanguageAvailable(String language) async {
    return await Tts.isLanguageAvailable(language);
  }

  void speak(String text) {
    if (text == null || text.isEmpty) {
      return;
    }
    Tts.speak(text);
  }

  void setLanguageAndSpeak(String text, String language) async {
    String ttsL = _getTtsLanguage(language);
    var result = await _setLanguage(ttsL);
    if (result != null) {
      var available = await _isLanguageAvailable(ttsL);
      if (available != null) {
        speak(text);
      }
    }
  }
}