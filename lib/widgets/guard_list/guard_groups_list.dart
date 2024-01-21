import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assigned_team_member.dart';
import '../../providers/guard_groups_provider.dart';
import 'guard_group_tile.dart';

class GuardGroupsList extends StatefulWidget {
  List<List<AssignedTeamMember>> guardGroups = [];

  GuardGroupsList({Key? key}) : super(key: key);

  @override
  _GuardGroupsListState createState() => _GuardGroupsListState();
}

class _GuardGroupsListState extends State<GuardGroupsList> {
  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    widget.guardGroups = Provider.of<GuardGroupsProvider>(context).guardGroups;
    
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

                  Provider.of<GuardGroupsProvider>(context, listen: false)
                      .updateGuardGroups(widget.guardGroups);
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

void _swapGroupTimes(List<AssignedTeamMember> groupA, List<AssignedTeamMember> groupB) {
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

