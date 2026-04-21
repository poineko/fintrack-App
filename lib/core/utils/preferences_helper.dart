// lib/core/utils/preferences_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_strings.dart';

class PreferencesHelper {
  PreferencesHelper._();

  static Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppStrings.onboardingDoneKey) ?? false;
  }

  static Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.onboardingDoneKey, true);
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStrings.onboardingDoneKey);
  }
}
