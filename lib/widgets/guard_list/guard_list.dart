import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assigned_team_member_model.dart';
import '../../providers/guard_lists_provider.dart';
import 'guard_group_tile.dart';

class GuardList extends StatefulWidget {
  List<List<AssignedTeamMemberModel>> guardGroups = [];
  String name;

  GuardList({Key? key, required this.name, required this.guardGroups}) : super(key: key);

  @override
  _GuardListState createState() => _GuardListState();
}

class _GuardListState extends State<GuardList> {
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ReorderableListView.builder(
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
                  // Adjust for the removal of the item
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }

                  // Move the item in the list
                  final item = widget.guardGroups.removeAt(oldIndex);
                  widget.guardGroups.insert(newIndex, item);

                  // Swap times logic
                  if (newIndex < oldIndex) {
                    for (int i = newIndex; i < oldIndex; i++) {
                      _swapGroupTimes(widget.guardGroups[i], widget.guardGroups[i + 1]);
                    }
                  } else {
                    for (int i = newIndex; i > oldIndex; i--) {
                      _swapGroupTimes(widget.guardGroups[i], widget.guardGroups[i - 1]);
                    }
                  }

                  Provider.of<GuardListsProvider>(context, listen: false)
                      .updateGuardList(widget.name, widget.guardGroups);
                });
              },
            ),
    );
  }
}

void _swapGroupTimes(List<AssignedTeamMemberModel> groupA, List<AssignedTeamMemberModel> groupB) {
    DateTime tempStartTime = groupA[0].startTime;
    DateTime tempEndTime = groupA[0].endTime;

    groupA.forEach((member) {
      member.startTime = groupB[0].startTime;
      member.endTime = groupB[0].endTime;
    });

    groupB.forEach((member) {
      member.startTime = tempStartTime;
      member.endTime = tempEndTime;
    });
}

