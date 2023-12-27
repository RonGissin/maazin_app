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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        fontFamily: "BlackOpsOne"
      ),
      home: MaazinHomePage(),
    );
  }
}


class MaazinHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined, // Replace with your desired icon
              color: secondaryColor,
              size: 30.0,
            ),
            SizedBox(width: 5.0), // Add spacing between icon and text
            Text(
              'Maazin',
              style: TextStyle(
                color: secondaryColor,
               fontSize: 30),
            ),
          ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group, // Replace with your desired icon
                      color: secondaryColor,
                    ),
                    SizedBox(width: 5.0), // Add spacing between icon and text
                    Text('My Team'),
                  ],
              )),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.security, // Replace with your desired icon
                      color: secondaryColor,
                    ),
                    SizedBox(width: 5.0), // Add spacing between icon and text
                    Text('Guard List'),
                  ],
              )),
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
