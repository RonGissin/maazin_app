import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart';
import '../models/team_member.dart';
import '../widgets/modify_team_member_dialog.dart';

class TeamList extends StatelessWidget {
  const TeamList({Key? key});

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align icons to the right
                children: [
                  Expanded(child: Text(teamMembers[index].name)),
                  IconButton(
                    icon: Icon(Icons.edit),  // Add your first IconButton
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModifyTeamMemberDialog(
                            teamMembers: teamMembers,
                            title: 'Edit Team Member',
                            actionButtonText: 'Edit',
                            onActionButtonPressed: (String newName) => Provider.of<TeamProvider>(context, listen: false).editTeamMember(teamMembers[index].name, newName));
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),  // Existing IconButton
                    onPressed: () {
                      // Use TeamProvider to remove the team member
                      Provider.of<TeamProvider>(context, listen: false).removeTeamMember(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
