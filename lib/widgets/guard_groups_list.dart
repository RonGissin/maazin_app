import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import '../date_formatter.dart';

class GuardGroupsList extends StatelessWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  const GuardGroupsList({super.key, required this.guardGroups});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
      itemCount: guardGroups.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
          title: Text('${guardGroups[index].map((e) => '${e.name} ').join(',')}${DateFormatter.formatTime(guardGroups[index][0].startTime)} - ${DateFormatter.formatTime(guardGroups[index][0].endTime)}'),
          // Add more details or actions as needed
        ));
      },
    ),);
  }

  String getReadableList() {
    StringBuffer formattedList = StringBuffer();
    formattedList.writeln('**Guard List**'); // WhatsApp markdown for bold text

    for (int i = 0; i < guardGroups.length; i++) {
      formattedList.writeln('Group ${i + 1}:');

      for (int j = 0; j < guardGroups[i].length; j++) {
        formattedList.writeln(
          '- ${guardGroups[i][j].name} - ${DateFormatter.formatTime(guardGroups[i][j].startTime)} to ${DateFormatter.formatTime(guardGroups[i][j].endTime)}',
        );
      }
    }

    return formattedList.toString();
  }
}
