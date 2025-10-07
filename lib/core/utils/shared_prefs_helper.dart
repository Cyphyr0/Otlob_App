import "package:shared_preferences/shared_preferences.dart";

class SharedPrefsHelper {
  static const String _onboardingCompletedKey = "onboarding_completed";
  static const String _authenticatedKey = "is_authenticated";

  static Future<bool> isOnboardingCompleted() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, completed);
  }

  static Future<bool> isAuthenticated() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authenticatedKey) ?? false;
  }

  static Future<void> setAuthenticated(bool authenticated) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authenticatedKey, authenticated);
  }
}
