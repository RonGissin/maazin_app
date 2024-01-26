import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/team_provider.dart';
import '../../models/team_member_model.dart';
import '../generic/dismissable_reorderable_list_view.dart';
import 'modify_team_member_dialog.dart';

class TeamList extends StatefulWidget {
  const TeamList({Key? key}) : super(key: key);

  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  @override
  Widget build(BuildContext context) {
    List<TeamMemberModel> teamMembers = Provider.of<TeamProvider>(context).teamMembers;

    return Expanded(
        child: DismissableReorderableListView(
          itemKeyPrefix: "team-list",
          itemCount: teamMembers.length,
          items: teamMembers,
          onReorder: (int oldIndex, int newIndex) {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            setState(() {
              final TeamMemberModel item = teamMembers.removeAt(oldIndex);
              teamMembers.insert(newIndex, item);
              Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
            });
          },
          extractNameFromItem: (i) => i.name,
          extractItemIsEnabledState: (i) => i.isEnabled,
          onItemDismissed: (direction, index) {
            Provider.of<TeamProvider>(context, listen: false).removeTeamMember(index);
          },
          onItemEnableToggle: (tm) {
            setState(() {
              tm.isEnabled = !tm.isEnabled;
              Provider.of<TeamProvider>(context, listen: false).saveTeamMembers();
            });
          },
          onModifyItem: (TeamMemberModel tm, String newName) {
            Provider.of<TeamProvider>(context, listen: false)
                .editTeamMember(tm.name, newName);
          },
          modifyItemDialogText: "Edit Team Member",
        )

    );
  }
}
