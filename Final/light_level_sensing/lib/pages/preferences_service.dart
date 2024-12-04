import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModePreference {
  light,
  dark,
}


class PreferencesService {
  static const String themeModeKey = 'theme_mode';

  Future<void> setThemeMode(ThemeModePreference themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themeModeKey, themeMode == ThemeModePreference.light ? 'light' : 'dark');
  }

  Future<ThemeModePreference> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(themeModeKey) ?? 'light';
    return themeModeString == 'light' ? ThemeModePreference.light : ThemeModePreference.dark;
  }
}
