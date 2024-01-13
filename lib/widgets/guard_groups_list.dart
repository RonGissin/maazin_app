import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import 'guard_group_tile.dart'; // Import the new tile widget
import '../date_formatter.dart';

class GuardGroupsList extends StatefulWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  const GuardGroupsList({Key? key, required this.guardGroups}) : super(key: key);

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

  @override
  _GuardGroupsListState createState() => _GuardGroupsListState();
}

class _GuardGroupsListState extends State<GuardGroupsList> {
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget.guardGroups.isEmpty
          ? _buildNoListWidget()
          : ReorderableListView.builder(
              itemCount: widget.guardGroups.length,
              itemBuilder: (context, index) {
                return GuardGroupTile(
                  key: ValueKey(widget.guardGroups[index]),
                  groupMembers: widget.guardGroups[index],
                  colorScheme: scheme,
                );
              },
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = widget.guardGroups.removeAt(oldIndex);
                  widget.guardGroups.insert(newIndex, item);
                });
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
}

