import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import '../date_formatter.dart';

class GuardGroupsList extends StatelessWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  const GuardGroupsList({Key? key, required this.guardGroups}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Color invPrimaryColor = scheme.inversePrimary;
    Color primaryColor = scheme.primary;
    var isEmpty = guardGroups.isEmpty;

    var listWidget = _getListWidget(isEmpty, primaryColor, invPrimaryColor);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: listWidget
    );
  }

  Widget _getListWidget(bool isEmpty, Color primary, Color inversePrimary) {
    var noListTextColumn = const Card(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text("No list yet..", style: TextStyle(fontSize: 15))
          )),
          Padding(
            padding: EdgeInsets.all(10), 
            child: Center(
              child: Text("press the edit button to generate a list", style: TextStyle(fontSize: 15))
          )),
        ],
    ));

    var widget = isEmpty ? 
      noListTextColumn : 
      ListView.builder(
        itemCount: guardGroups.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Wrap(
                children: [
                  ...guardGroups[index].map(
                    (e) => FittedBox(
                      child: Container(
                        height: 50.0, // Adjust the height as needed
                        child: Card(
                          elevation: 3,
                          color: inversePrimary,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(e.name),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Container(
                      height: 50.0, // Adjust the height as needed
                      child: Card(
                        color: primary,
                        elevation: 3,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '${DateFormatter.formatTime(guardGroups[index][0].startTime)} - ${DateFormatter.formatTime(guardGroups[index][0].endTime)}',
                              style: TextStyle(color: inversePrimary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Add more details or actions as needed
            ),
          );
        },
      );

      return widget;
  }

  String getReadableList() {
    StringBuffer formattedList = StringBuffer();
    formattedList.writeln('*Guard List*'); // WhatsApp markdown for bold text

    for (int i = 0; i < guardGroups.length; i++) {
      formattedList.write('- ');
      for (int j = 0; j < guardGroups[i].length; j++) {
        formattedList.write('${guardGroups[i][j].name}');
        if (j < guardGroups[i].length - 1) {
          formattedList.write(', ');
        }
      }
      formattedList.write(' - ${DateFormatter.formatTime(guardGroups[i][0].startTime)} to ${DateFormatter.formatTime(guardGroups[i][0].endTime)}\n');
    }

    return formattedList.toString();
  }
}
