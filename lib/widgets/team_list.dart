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
      child: ReorderableListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          TeamMember teamMember = teamMembers[index];

          return ReorderableDelayedDragStartListener(
            key: Key(teamMember.name),
            index: index,
            child: Dismissible(
              key: Key(teamMember.name),
              direction: DismissDirection.startToEnd, // Changed direction
              background: Container(
                color: Colors.transparent,
                alignment: Alignment.centerLeft, // Align to the left
                child: Material(
                  elevation: 1.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    child: Container(
                      height: 65.0,
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onDismissed: (direction) {
                Provider.of<TeamProvider>(context, listen: false).removeTeamMember(index);
              },
              child: Card(
                child: Opacity(
                  opacity: teamMember.isEnabled ? 1.0 : 0.3,
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
                              setState(() {});
                            },
                          ),
                        if (!teamMember.isEnabled)
                          IconButton(
                            icon: Icon(Icons.do_not_disturb),
                            onPressed: () {
                              teamMember.isEnabled = true;
                              Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
                              setState(() {});
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
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          setState(() {
            final TeamMember item = teamMembers.removeAt(oldIndex);
            teamMembers.insert(newIndex, item);
            Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
          });
        },
      ),
    );
  }
}
