import 'package:qltstc_kiemke/constants/configs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static late SharedPreferences _instance;

  static setInstance(SharedPreferences ins) {
    SharedPreferencesUtils._instance = ins;
  }

  ///Get Singleton instance
  static SharedPreferences sharedPreferencesInstance() {
    return _instance;
  }

  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _kLanguageCode = "language";
  static final String _userGUID = "userGUID";
  static final String _token = "token";

  /// ------------------------------------------------------------
  /// Method that returns the user language code, 'en' if not set
  /// ------------------------------------------------------------
  static String getLanguageCode() {
    return _instance.getString(_kLanguageCode) ?? "";
  }

  /// ----------------------------------------------------------
  /// Method that saves the user language code
  /// ----------------------------------------------------------
  static void setLanguageCode(String value) {
    _instance.setString(_kLanguageCode, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the user GUID ,'' if not set
  /// ------------------------------------------------------------
  static String getUserGUID() {
    return _instance.getString(_userGUID) ?? "";
  }

  /// ----------------------------------------------------------
  /// Method that saves the user GUID
  /// ----------------------------------------------------------
  static void setUserGUID(String value) {
    _instance.setString(_userGUID, value);
  }

  /// ------------------------------------------------------------
  /// Method that returns the _token ,'' if not set
  /// ------------------------------------------------------------
  static String getToken() {
    return _instance.getString(_token) ?? "";
  }

  /// ----------------------------------------------------------
  /// Method that saves the _token
  /// ----------------------------------------------------------
  static void setToken(String? value) {
    _instance.setString(_token, value ?? "");
  }

  static final String _themeId = "themeId";

  static void setTheme(int theme) {
    _instance.setInt(_themeId, theme);
  }

  static int getTheme() {
    return _instance.getInt(_themeId) ?? Config.THEME_SYSTEM_MODE;
  }
}
