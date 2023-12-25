import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import '../../date_formatter.dart';

class GuardGroupsList extends StatelessWidget {
  final List<List<AssignedTeamMember>> guardGroups;

  GuardGroupsList({required this.guardGroups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: guardGroups.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
          title: Text(guardGroups[index].map((e) => '${e.name} ').join(',') + '${DateFormatter.formatTime(guardGroups[index][0].startTime)} - ${DateFormatter.formatTime(guardGroups[index][0].endTime)}'),
          // Add more details or actions as needed
        ));
      },
    );
  }
}
