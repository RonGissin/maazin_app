import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_settings.dart';

class AppSettingsProvider extends ChangeNotifier {
  late AppSettings _settings;

  AppSettings get settings => _settings;

  // Initialize the state by loading settings from SharedPreferences
  Future<void> init() async {
    await loadSettings();
  }

  // Load setatings from SharedPreferences
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? numberOfConcurrentGuards = prefs.getInt('numberOfConcurrentGuards');

    _settings = AppSettings(numberOfConcurrentGuards: numberOfConcurrentGuards ?? 2);
    notifyListeners();
  }

  // Add a new team member
  void editSettings(AppSettings newSettings) {
    _settings = newSettings;
    _saveSettings();
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('numberOfConcurrentGuards', _settings.numberOfConcurrentGuards);
    notifyListeners();
  }
}
