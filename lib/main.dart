import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/team_list_screen.dart';
import 'screens/guard_list_screen.dart';
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
        primarySwatch: Colors.green,
      ),
      home: MaazinHomePage(),
    );
  }
}

class MaazinHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Maazin'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Your Team'),
              Tab(text: 'Guard List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TeamListScreen(),
            GuardListScreen(),
          ],
        ),
      ),
    );
  }
}
