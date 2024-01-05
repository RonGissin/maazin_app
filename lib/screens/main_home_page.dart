import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './team_list_screen.dart';
import './guard_list_screen.dart';

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
            SvgPicture.asset(
              'assets/logo.svg',  // Replace with the path to your SVG file
              width: 72,  // Set the desired width
              height: 72, // Set the desired height
              color: secondaryColor
            ),
            SizedBox(width: 5.0), // Add spacing between icon and text
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
