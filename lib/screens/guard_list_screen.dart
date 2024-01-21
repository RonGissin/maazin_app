import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../models/assigned_team_member.dart';
import '../guard_list_generator.dart';
import '../widgets/guard_list/generate_list_modal.dart';
import '../widgets/guard_list/guard_groups_list.dart';
import '../providers/team_provider.dart';
import '../providers/guard_groups_provider.dart';
import '../widgets/guard_list/guard_list_screen_bottom_app_bar.dart';

class GuardListScreen extends StatefulWidget {
  const GuardListScreen({Key? key}) : super(key: key);

  @override
  _GuardListScreenState createState() => _GuardListScreenState();
}

class _GuardListScreenState extends State<GuardListScreen>
    with AutomaticKeepAliveClientMixin {
  GuardListGenerator generator = GuardListGenerator();
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();
  bool isInvalidTime = false;
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

    List<List<AssignedTeamMember>> generatedGroups = generator.generateGuardGroups(
      Provider.of<TeamProvider>(context, listen: false).teamMembers,
      numberOfConcurrentGuards,
      startTime,
      endTime,
      isFixedGuardTime ? guardTime : null,
    );

    Provider.of<GuardGroupsProvider>(context, listen: false)
        .updateGuardGroups(generatedGroups);

    if (generatedGroups.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Guarding Period"),
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
    List<List<AssignedTeamMember>> guardGroups = Provider.of<GuardGroupsProvider>(context).guardGroups;
    GuardGroupsList guardGroupsList = GuardGroupsList();

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
            guardGroupsList,
            Align(
              alignment: Alignment.bottomCenter,
              child: GuardListScreenBottomAppBar(
                isAppBarVisible: isAppBarVisible,
                guardGroups: guardGroups,
                onAddOrEditPressed: () {
                  _showGenerateListModal(
                    context,
                    selectedStartTime,
                    selectedEndTime, 
                    (time) => setState(() => selectedStartTime = time), 
                    (time) => setState(() => selectedEndTime = time));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }}