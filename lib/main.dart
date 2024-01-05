import 'package:flutter/material.dart';
import 'package:maazin_app/screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'team_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TeamProvider()),
      ],
    child: MaazinApp())
  );
}

class MaazinApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the TeamProvider and call the init method
    Provider.of<TeamProvider>(context, listen: false).init();

    return MaterialApp(
      title: 'Maazin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        fontFamily: "BlackOpsOne"
      ),
      home: LoadingScreen(),

    );
  }
}