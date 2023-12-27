import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import '../date_formatter.dart';

class GuardGroupsList extends StatelessWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  const GuardGroupsList({super.key, required this.guardGroups});

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    Color invPrimaryColor = scheme.inversePrimary;
    Color primaryColor = scheme.primary;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: guardGroups.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  ...guardGroups[index].map((e) => 
                    Container(
                      height: 50.0, // Adjust the height as needed
                      child: Card(
                        elevation: 3,
                        color: invPrimaryColor,
                        child: Center(
                          child: Padding(padding: EdgeInsets.all(10), child: Text(e.name))
                          ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0, // Adjust the height as needed
                    child: Card(
                      color: primaryColor,
                      elevation: 3,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                          '${DateFormatter.formatTime(guardGroups[index][0].startTime)} - ${DateFormatter.formatTime(guardGroups[index][0].endTime)}',
                          style: TextStyle(color: invPrimaryColor),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              // Add more details or actions as needed
            ),
          );
        },
      ),
    );
  }

  String getReadableList() {
    StringBuffer formattedList = StringBuffer();
    formattedList.writeln('**Guard List**'); // WhatsApp markdown for bold text

    for (int i = 0; i < guardGroups.length; i++) {
      for (int j = 0; j < guardGroups[i].length; j++) {
        formattedList.writeln(
          '- ${guardGroups[i][j].name} - ${DateFormatter.formatTime(guardGroups[i][j].startTime)} to ${DateFormatter.formatTime(guardGroups[i][j].endTime)}',
        );
      }
    }

    return formattedList.toString();
  }
}
