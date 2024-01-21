import 'package:flutter/material.dart';
import '../../models/assigned_team_member.dart';
import '../../utils/date_formatter.dart';

class GuardGroupTile extends StatefulWidget {
  final List<AssignedTeamMember> groupMembers;
  final ColorScheme colorScheme;

  const GuardGroupTile({
    Key? key,
    required this.groupMembers,
    required this.colorScheme,
  }) : super(key: key);

  @override
  _GuardGroupTileState createState() => _GuardGroupTileState();
}

class _GuardGroupTileState extends State<GuardGroupTile> {

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: widget.groupMembers.indexOf(widget.groupMembers.first),
      child: Card(
          child: InkWell(
            onTap: () {}, // Implement onTap logic if needed
            borderRadius: BorderRadius.circular(10),
            child: ListTile(
            title: Wrap(
              children: [
                ...widget.groupMembers.map(
                  (e) => FittedBox(
                    child: Container(
                      height: 50.0,
                      child: Card(
                        elevation: 3,
                        color: widget.colorScheme.inversePrimary,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(e.name),
                          ),
                        ),
                      ),
                    ),
                  ),
                ).toList(),
                FittedBox(
                  child: Container(
                    height: 50.0,
                    child: Card(
                      color: widget.colorScheme.primary,
                      elevation: 3,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${DateFormatter.formatTime(widget.groupMembers[0].startTime)} - ${DateFormatter.formatTime(widget.groupMembers[0].endTime)}',
                            style: TextStyle(color: widget.colorScheme.inversePrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

