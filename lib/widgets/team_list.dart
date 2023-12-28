import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../team_provider.dart';
import '../models/team_member.dart';
import '../widgets/modify_team_member_dialog.dart';


class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {

  @override
  Widget build(BuildContext context) {
    List<TeamMember> teamMembers = Provider.of<TeamProvider>(context).teamMembers;

    return Expanded(
      child: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          TeamMember teamMember = teamMembers[index];

          return Card(
            child: Opacity(
              opacity: teamMember.isEnabled ? 1.0 : 0.5, // Adjust the opacity value as needed
              child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(teamMember.name)),
                  if (teamMember.isEnabled)
                    IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        teamMember.isEnabled = false;
                        Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
                        setState(() => {});
                      },
                    ),
                  if (!teamMember.isEnabled)
                    IconButton(
                      icon: Icon(Icons.do_not_disturb),
                      onPressed: () {
                        teamMember.isEnabled = true;
                        Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
                        setState(() => {});
                      },
                    ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModifyTeamMemberDialog(
                            teamMembers: teamMembers,
                            title: 'Edit Team Member',
                            actionButtonText: 'Edit',
                            onActionButtonPressed: (String newName) =>
                                Provider.of<TeamProvider>(context, listen: false)
                                    .editTeamMember(teamMember.name, newName),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, index, teamMember.name);
                    },
                  ),
                ],
              ),
            )),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int teamMemberIndex, String teamMemberName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to delete $teamMemberName from the team?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Delete the team member
                Provider.of<TeamProvider>(context, listen: false).removeTeamMember(teamMemberIndex);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}