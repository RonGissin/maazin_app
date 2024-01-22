import 'package:shared_preferences/shared_preferences.dart';

const String _onboardingCompletePref = 'onboardingComplete';

class OnboardingStatusProvider {
  // Load team members from SharedPreferences
  Future<bool> isOnboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletePref) ?? false;
  }

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_onboardingCompletePref, true);
  }
}