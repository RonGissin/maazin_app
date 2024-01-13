import '../utils/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maazin_app/widgets/generate_list_modal.dart';
import 'package:maazin_app/guard_list_generator.dart';
import 'package:maazin_app/models/assigned_team_member.dart';
import 'package:maazin_app/models/team_member.dart';
import 'package:maazin_app/widgets/guard_groups_list.dart';
import 'package:provider/provider.dart';
import 'package:maazin_app/team_provider.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

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
            onGenerateList: _generateList,
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
  var scheme = Theme.of(context).colorScheme;
  teamMembers = Provider.of<TeamProvider>(context).teamMembers;
  guardGroupsList = GuardGroupsList(guardGroups: guardGroups);

  List<Widget> fabWidgets = guardGroups.isEmpty 
    ? [      FloatingActionButton(        onPressed: () {          _showGenerateListModal(              context,              selectedStartTime,              selectedEndTime,              (time) => setState(() => selectedStartTime = time),              (time) => setState(() => selectedEndTime = time));        },        child: const Icon(Icons.add),      ),    ]
    : [      FloatingActionButton(        onPressed: () {          Clipboard.setData(              ClipboardData(text: guardGroupsList.getReadableList()));          SnackbarUtil.showSnackBar(context, 'List Copied!');        },        child: const Icon(Icons.copy),      ),      SizedBox(width: 16),      FloatingActionButton(        onPressed: () {          final String readableList = guardGroupsList.getReadableList();          Share.share(readableList);        },        child: const Icon(Icons.share_sharp),      ),      SizedBox(width: 16),      FloatingActionButton(        onPressed: () {          _showGenerateListModal(              context,              selectedStartTime,              selectedEndTime,              (time) => setState(() => selectedStartTime = time),              (time) => setState(() => selectedEndTime = time));        },        child: const Icon(Icons.edit),      ),    ];

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
            if (isAppBarVisible) setState(() => isAppBarVisible = false);
          } else if (notification.direction == ScrollDirection.forward) {
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
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border.all(
                      color: scheme.primary,
                      width: 3.0,
                    ),
                  ), 
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
                )),
            ),
          ),
        ],
      ),
    ),
  );
  }
}

