import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkThemeData = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF202020),
    ),
    scaffoldBackgroundColor: const Color(0xFF202020),
    primaryColor: const Color(0xFF2F2F2F),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xFF2F2F2F)),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(
      color: Colors.white,
    )));

final lightThemeData = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(color: Color(0xFFEFF1F3)),
    scaffoldBackgroundColor: const Color(0xFFEFF1F3),
    primaryColor: const Color(0xFFDEDEDE),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xFFDEDEDE)),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(
      color: Colors.black,
    )));

final blueThemeData = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(color: Color(0xFF0C0811)),
    scaffoldBackgroundColor: const Color(0xFF0C0811),
    primaryColor: const Color(0xFF14141C),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xFF1A1B29)),
    dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(
      color: Colors.white,
    )));

final List<ThemeData> themes = [lightThemeData, darkThemeData, blueThemeData];

class ThemeProvider with ChangeNotifier {
  static const String _themeIndexKey = 'themeIndex';
  int _themeIndex = 0;

  ThemeProvider() {
    load();
  }

  int get themeIndex => _themeIndex;

  void changeTheme(int newIndex) {
    _themeIndex = newIndex;
    saveThemeIndex(newIndex);
    notifyListeners();
  }

  Future<int> loadThemeIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(_themeIndexKey) ?? 0;
  }

  Future<void> saveThemeIndex(int index) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setInt(_themeIndexKey, index);
  }

  Future<void> load() async {
    _themeIndex = await loadThemeIndex();
    notifyListeners();
  }
}

class TextProvider with ChangeNotifier {
  static const String _textThemeKey = 'text_theme';
  String _textTheme = 'Светлая';

  TextProvider() {
    load();
  }

  String get textTheme => _textTheme;

  void changeTextTheme(String newText) {
    _textTheme = newText;
    saveThemeText(newText);
    notifyListeners();
  }

  Future<String> loadThemeText() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_textThemeKey) ?? 'Светлая';
  }

  Future<void> saveThemeText(String text) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_textThemeKey, text);
  }

  Future<void> load() async {
    _textTheme = await loadThemeText();
    notifyListeners();
  }
}

class SizeTextProvider with ChangeNotifier {
  static const String _sizeTextThemeKey = 'size_text_theme';
  double _sizeTextTheme = 20;

  SizeTextProvider() {
    load();
  }

  double get sizeTextTheme => _sizeTextTheme;

  void changeTextTheme(double newSize) {
    _sizeTextTheme = newSize;
    saveThemeText(newSize);
    notifyListeners();
  }

  Future<double> loadThemeText() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble(_sizeTextThemeKey) ?? 20;
  }

  Future<void> saveThemeText(double size) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setDouble(_sizeTextThemeKey, size);
  }

  Future<void> load() async {
    _sizeTextTheme = await loadThemeText();
    notifyListeners();
  }
}

class ChatViewProvider with ChangeNotifier {
  static const String _chatViewKey = 'chat_view_key';

  bool _isClassic = true;

  ChatViewProvider() {
    _loadView();
  }

  bool get isClassicView => _isClassic;

  void changeView() {
    _isClassic = !_isClassic;
    _saveView();
    notifyListeners();
  }

  Future<void> _loadView() async {
    final prefs = await SharedPreferences.getInstance();

    _isClassic = prefs.getBool(_chatViewKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveView() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(_chatViewKey, _isClassic);
  }
}

class ViewTextProvider with ChangeNotifier {
  static const String _viewTextThemeKey = 'viewText_theme';
  String _viewTextTheme = 'Классический';

  ViewTextProvider() {
    load();
  }

  String get viewTextTheme => _viewTextTheme;

  void changeTextTheme(String newText) {
    _viewTextTheme = newText;
    saveThemeText(newText);
    notifyListeners();
  }

  Future<String> loadThemeText() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_viewTextThemeKey) ?? 'Классический';
  }

  Future<void> saveThemeText(String text) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(_viewTextThemeKey, text);
  }

  Future<void> load() async {
    _viewTextTheme = await loadThemeText();
    notifyListeners();
  }
}
