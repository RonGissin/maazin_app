import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/manage_personnel.dart';
import 'screens/generated_lists.dart';
import 'team_provider.dart';
import 'app_settings_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (context) => TeamProvider()),
      ],
    child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the TeamProvider and call the init method
    Provider.of<TeamProvider>(context, listen: false).init();
    Provider.of<AppSettingsProvider>(context, listen: false).init();

    return MaterialApp(
      title: 'Maazin',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Maazin'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Manage Personnel'),
              Tab(text: 'Generate a List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ManagePersonnelScreen(),
            GeneratedListsScreen(),
          ],
        ),
      ),
    );
  }
}
