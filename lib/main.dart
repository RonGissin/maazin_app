import 'package:flutter/material.dart';
import 'package:maazin_app/providers/guard_groups_provider.dart';
import 'package:maazin_app/screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'providers/team_provider.dart';
import 'providers/onboarding_status_provider.dart';
import 'screens/introduction/introduction_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final onboardingStatusProvider = OnboardingStatusProvider();

  final skipIntro = await onboardingStatusProvider.isOnboardingComplete();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TeamProvider()),
        ChangeNotifierProvider(create: (context) => GuardGroupsProvider()),
      ],
    child: MaazinApp(skipIntro: skipIntro))
  );
}

class MaazinApp extends StatelessWidget {
  const MaazinApp({super.key, required this.skipIntro});

  final bool skipIntro;

  @override
  Widget build(BuildContext context) {
    // Access the TeamProvider and call the init method
    Provider.of<TeamProvider>(context, listen: false).init();
    Provider.of<GuardGroupsProvider>(context, listen: false).init();

    return MaterialApp(
      title: 'Maazin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        fontFamily: "BlackOpsOne"
      ),
      home: skipIntro ? LoadingScreen() : IntroductionScreen(),
    );
  }
}