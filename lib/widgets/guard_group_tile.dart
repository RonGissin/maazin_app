import 'package:flutter/material.dart';
import '../models/assigned_team_member.dart';
import '../date_formatter.dart';

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

class _GuardGroupTileState extends State<GuardGroupTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: widget.groupMembers.indexOf(widget.groupMembers.first),
      child: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.5).animate(_controller),
        child: Card(
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