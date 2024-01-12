import 'dart:async';
import '../widgets/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maazin_app/widgets/generate_list_modal.dart'; // Import the GenerateListModal class
import 'package:maazin_app/guard_list_generator.dart';
import 'package:maazin_app/models/assigned_team_member.dart';
import 'package:maazin_app/models/team_member.dart';
import 'package:maazin_app/widgets/guard_groups_list.dart';
import 'package:provider/provider.dart';
import 'package:maazin_app/team_provider.dart'; // Import the TeamProvider class
import 'package:flutter/services.dart';
import 'package:share/share.dart'; // Import the share package

class GuardListScreen extends StatefulWidget {
  const GuardListScreen({Key? key}) : super(key: key);

  @override
  _GuardListScreenState createState() => _GuardListScreenState();
}

class _GuardListScreenState extends State<GuardListScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<List<AssignedTeamMember>> guardGroups = [];
  List<TeamMember> teamMembers = [];
  GuardListGenerator generator = GuardListGenerator();
  int numberOfConcurrentGuards = 1;
  late GuardGroupsList guardGroupsList;
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  bool isInvalidTime = false;
  int? intGuardTime;
  TextEditingController doubleGuardTimeController = TextEditingController();
  bool isFixedGuardTime = false;
  bool isAppBarVisible = true;
  late AnimationController _controller;
  double _glowRadius = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _startGlowAnimation();
  }

  void _startGlowAnimation() {
    // Repeat the animation
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _glowRadius = _glowRadius == 1.0 ? 6.0 : 1.0; // Toggle the glow radius
      });
    });
  }

  Widget _buildGlowingFAB(IconData icon, VoidCallback onPressed, Color glowColor) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 167, 235, 89).withOpacity(0.5),
            spreadRadius: _glowRadius,
            blurRadius: 5,
            offset: Offset(0.0, 0.0), // changes position of shadow
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _showGenerateListModal(
      BuildContext context,
      DateTime previousStartTime,
      DateTime previousEndTime,
      void Function(DateTime) onSetStartTime,
      void Function(DateTime) onSetEndTime) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: GenerateListModal(
            onGenerateList: _generateList, // Pass the callback function
            previousStartTime: previousStartTime,
            previousEndTime: previousEndTime,
            onSetStartTime: onSetStartTime,
            onSetEndTime: onSetEndTime,
        ));
      },
    );
  }

  void _generateList(
    DateTime startTime,
    DateTime endTime,
    int? guardTime,
    int numberOfConcurrentGuards,
    bool isFixedGuardTime,
  ) {
    setState(() {
      isInvalidTime = startTime.isAfter(endTime);
    });

    if (isInvalidTime) {
      return;
    }

    setState(() {
      guardGroups = generator.generateGuardGroups(
        teamMembers,
        numberOfConcurrentGuards,
        startTime,
        endTime,
        isFixedGuardTime ? guardTime : null,
      );
    });

    if (guardGroups.isEmpty) {
      // Display a dialog if the guardGroups is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Guarding Period", style: TextStyle(color: Color.fromARGB(255, 255, 196, 0))),
            content: Text("Please make sure you enter a guarding period that is long enough to assign a guard."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context); // Close the modal if guardGroups is not empty
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var scheme = Theme.of(context).colorScheme;
    teamMembers = Provider.of<TeamProvider>(context).teamMembers;
    guardGroupsList = GuardGroupsList(guardGroups: guardGroups);

    List<Widget> fabWidgets = guardGroups.isEmpty 
      ? [
          FloatingActionButton(
            onPressed: () {
              _showGenerateListModal(
                  context,
                  selectedStartTime,
                  selectedEndTime,
                  (time) => setState(() => selectedStartTime = time),
                  (time) => setState(() => selectedEndTime = time));
            },
            child: const Icon(Icons.add),
          ),
        ]
      : [
          _buildGlowingFAB(Icons.copy, () {
            Clipboard.setData(
                ClipboardData(text: guardGroupsList.getReadableList()));
            SnackbarUtil.showSnackBar(context, 'List Copied!');
          }, scheme.secondary),
          SizedBox(width: 16),
          _buildGlowingFAB(Icons.share_sharp, () {
            final String readableList = guardGroupsList.getReadableList();
            Share.share(readableList);
          }, scheme.secondary),
          SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              _showGenerateListModal(
                  context,
                  selectedStartTime,
                  selectedEndTime,
                  (time) => setState(() => selectedStartTime = time),
                  (time) => setState(() => selectedEndTime = time));
            },
            child: const Icon(Icons.edit),
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Guard List',
          style: TextStyle(color: scheme.secondary),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (guardGroups.isEmpty) {
            setState(() => isAppBarVisible = true);
          } else {
            if (notification.direction == ScrollDirection.reverse) {
              // User scrolled down
              if (isAppBarVisible) setState(() => isAppBarVisible = false);
            } else if (notification.direction == ScrollDirection.forward) {
              // User scrolled up
              if (!isAppBarVisible) setState(() => isAppBarVisible = true);
            }
          }
          return true;
        },
        child: Stack(
          children: [
            guardGroupsList, // Full screen height
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: isAppBarVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: BottomAppBar(
                    notchMargin: 4.0,
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: fabWidgets,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}