import 'package:flutter/material.dart';
import 'package:maazin_app/models/team_member.dart';
import 'package:provider/provider.dart';
import '../widgets/team_list.dart';
import '../providers/team_provider.dart';
import '../widgets/modify_team_member_dialog.dart';

class TeamListScreen extends StatelessWidget {
  const TeamListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    List<TeamMember> teamMembers = Provider.of<TeamProvider>(context).teamMembers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Team Members',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Text("${teamMembers.where((tm) => tm.isEnabled).length} available of ${teamMembers.length}")
              )),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModifyTeamMemberDialog(
                      teamMembers: teamMembers,
                      title: 'Add Team Member',
                      actionButtonText: 'Add',
                      onActionButtonPressed: (String newName) => Provider.of<TeamProvider>(context, listen: false).addTeamMember(newName));
                  },
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Team Member'),
            ),
            const SizedBox(height: 16.0),
            const TeamList(),
          ],
        ),
      ),
    );
  }
}


