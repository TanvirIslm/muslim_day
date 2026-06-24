import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranSettings extends ChangeNotifier {
  late SharedPreferences _prefs;

  static const double _defaultArabicFontSize = 25.0;
  static const double _defaultTranslationFontSize = 16.0;
  static const String _defaultArabicFont = 'Amiri';
  static const bool _defaultShowTranslation = true;

  double _arabicFontSize = _defaultArabicFontSize;
  double _translationFontSize = _defaultTranslationFontSize;
  String _arabicFont = _defaultArabicFont;
  bool _showTranslation = _defaultShowTranslation;

  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  String get arabicFont => _arabicFont;
  bool get showTranslation => _showTranslation;

  String? get arabicFontFamily {
    if (_arabicFont == 'IndoPak') {
      // Custom IndoPak font from assets (pubspec.yaml registered family: IndoPak)
      return 'IndoPak';
    }
    if (_arabicFont == 'NotoNaskhArabic') {
      return GoogleFonts.notoNaskhArabic().fontFamily;
    }
    if (_arabicFont == 'Lateef') {
      return GoogleFonts.lateef().fontFamily;
    }
    if (_arabicFont == 'Amiri') {
      return GoogleFonts.amiri().fontFamily;
    }
    if (_arabicFont == 'NotoKufiArabic') {
      return GoogleFonts.notoKufiArabic().fontFamily;
    }
    return GoogleFonts.amiri().fontFamily;
  }

  QuranSettings() {
    _loadSettings();
  }

  void updateArabicFontSize(double newSize) {
    _arabicFontSize = newSize;
    _prefs.setDouble('arabicFontSize', newSize);
    notifyListeners();
  }

  void updateTranslationFontSize(double newSize) {
    _translationFontSize = newSize;
    _prefs.setDouble('translationFontSize', newSize);
    notifyListeners();
  }

  void updateArabicFont(String newFont) {
    _arabicFont = newFont;
    _prefs.setString('arabicFont', newFont);
    notifyListeners();
  }

  void toggleTranslation(bool value) {
    _showTranslation = value;
    _prefs.setBool('showTranslation', value);
    notifyListeners();
  }

  Future<void> resetToDefault() async {
    _arabicFontSize = _defaultArabicFontSize;
    _translationFontSize = _defaultTranslationFontSize;
    _arabicFont = _defaultArabicFont;
    _showTranslation = _defaultShowTranslation;

    await _prefs.setDouble('arabicFontSize', _defaultArabicFontSize);
    await _prefs.setDouble('translationFontSize', _defaultTranslationFontSize);
    await _prefs.setString('arabicFont', _defaultArabicFont);
    await _prefs.setBool('showTranslation', _defaultShowTranslation);
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _arabicFontSize =
        _prefs.getDouble('arabicFontSize') ?? _defaultArabicFontSize;
    _translationFontSize =
        _prefs.getDouble('translationFontSize') ?? _defaultTranslationFontSize;
    _arabicFont = _prefs.getString('arabicFont') ?? _defaultArabicFont;
    _showTranslation =
        _prefs.getBool('showTranslation') ?? _defaultShowTranslation;

    notifyListeners();
  }
}
