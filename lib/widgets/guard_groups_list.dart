import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import 'guard_group_tile.dart'; // Import the new tile widget
import '../date_formatter.dart';

class GuardGroupsList extends StatelessWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  const GuardGroupsList({Key? key, required this.guardGroups}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: guardGroups.isEmpty
          ? _buildNoListWidget()
          : ListView.builder(
              itemCount: guardGroups.length,
              itemBuilder: (context, index) {
                return GuardGroupTile(
                  groupMembers: guardGroups[index],
                  colorScheme: scheme,
                );
              },
            ),
    );
  }

  Widget _buildNoListWidget() {
    return const Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text("No list yet..", style: TextStyle(fontSize: 15))
            )
          ),
          Padding(
            padding: EdgeInsets.all(10), 
            child: Center(
              child: Text("Press the + button to generate a list", style: TextStyle(fontSize: 15))
            )
          ),
        ],
      ),
    );
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
