import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart';
import '../models/team_member.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Provider to listen to changes in the team members
    List<TeamMember> teamMembers = Provider.of<TeamProvider>(context).teamMembers;

    return Expanded(
      child: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(teamMembers[index].name),
              trailing: IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  // Use TeamProvider to remove the team member
                  Provider.of<TeamProvider>(context, listen: false).removeTeamMember(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
