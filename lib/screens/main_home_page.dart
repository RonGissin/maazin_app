import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './team_list_screen.dart';
import './guard_list_screen.dart';
import '../widgets/settings_modal.dart';

class MaazinHomePage extends StatelessWidget {
  const MaazinHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/logo.svg', // Replace with the path to your SVG file
                    width: 72,  // Set the desired width
                    height: 72, // Set the desired height
                    color: secondaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.settings, color: secondaryColor),
                      onPressed: () {
                        showDialog(
                              context: context,
                              builder: (BuildContext context) => const SettingsModal(),
                            );
                      },
                  ),
                )),
              ],
          )),
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
                    const SizedBox(width: 5.0), // Add spacing between icon and text
                    const Text('My Team'),
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
                    const SizedBox(width: 5.0), // Add spacing between icon and text
                    const Text('Guard List'),
                  ],
              )),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TeamListScreen(),
            GuardListScreen(),
          ],
        ),
      ),
    );
  }
}
