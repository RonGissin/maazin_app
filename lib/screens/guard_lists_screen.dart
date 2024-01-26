import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maazin_app/models/guard_list_model.dart';
import 'package:maazin_app/screens/guard_list_preview_screen.dart';
import 'package:provider/provider.dart';
import '../models/assigned_team_member_model.dart';
import '../guard_list_generator.dart';
import '../models/generate_list_metadata.dart';
import '../widgets/generic/dismissable_reorderable_list_view.dart';
import '../widgets/guard_list/generate_list_modal.dart';
import '../providers/team_provider.dart';
import '../providers/guard_lists_provider.dart';
import '../widgets/guard_list/guard_lists_screen_bottom_app_bar.dart';
import 'guard_list_details_screen.dart';

class GuardListsScreen extends StatefulWidget {
  const GuardListsScreen({Key? key}) : super(key: key);

  @override
  _GuardListsScreenState createState() => _GuardListsScreenState();
}

class _GuardListsScreenState extends State<GuardListsScreen>
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

  void _generateList(GenerateListMetadata generateListMetadata) {
    setState(() {
      isInvalidTime = generateListMetadata.startTime.isAfter(generateListMetadata.endTime);
    });

    if (isInvalidTime) {
      return;
    }

    List<List<AssignedTeamMemberModel>> generatedGroups = generator.generateGuardGroups(
      Provider.of<TeamProvider>(context, listen: false).teamMembers,
      generateListMetadata.numberOfConcurrentGuards,
      generateListMetadata.startTime,
      generateListMetadata.endTime,
      generateListMetadata.isFixedGuardTime ? generateListMetadata.guardTime : null,
    );

    if (generatedGroups.isNotEmpty) {
      // Navigate to the preview screen with the generated list
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GuardListPreviewScreen(
            guardList: GuardListModel(name: generateListMetadata.listName, guardGroups: generatedGroups, metadata: generateListMetadata),
            onSave: () {
              _saveGuardList(generateListMetadata.listName, generatedGroups, generateListMetadata);
              setState(() {});
            },
            onShuffle: (guardList) => _shuffleList(guardList),
            generateListMetadata: generateListMetadata,
          ),
        ),
      );
  } else {
    _showInvalidPeriodDialog(context);
  }
  
  }
void _shuffleList(GuardListModel guardList) {
  Navigator.pop(context);
  _generateList(guardList.metadata);
}

void _saveGuardList(
  String listName,
  List<List<AssignedTeamMemberModel>> guardGroups,
  GenerateListMetadata metadata) {
    Provider.of<GuardListsProvider>(context, listen: false)
      .addGuardList(GuardListModel(name: listName, guardGroups: guardGroups, metadata: metadata));
}
  void _showInvalidPeriodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid Guarding Period"),
          content: const Text("Please make sure you enter a guarding period that is long enough to assign a guard."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var scheme = Theme.of(context).colorScheme;
    List<GuardListModel> guardLists = Provider.of<GuardListsProvider>(context).guardLists;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
          'Your Guard Lists',
          style: TextStyle(color: scheme.secondary),
        )),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (guardLists.isEmpty) {
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
              Column(
                children: guardLists.isEmpty ? 
                  [ 
                      _buildNoListWidget() 
                  ] :
                  [
                    _buildClearButton(context),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                        child: DismissableReorderableListView<GuardListModel>(
                          key: const Key("guard-lists-view"),
                          itemKeyPrefix: "guard-lists",
                          items: guardLists,
                          itemCount: guardLists.length,
                          onReorder: (int oldIndex, int newIndex) {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }

                            setState(() {
                              final GuardListModel item = guardLists.removeAt(oldIndex);
                              guardLists.insert(newIndex, item);
                              Provider.of<GuardListsProvider>(context, listen: false).saveGuardLists();
                            });
                          },
                          extractNameFromItem: (l) => l.name,
                          onItemDismissed: (direction, index) {
                            Provider.of<GuardListsProvider>(context, listen: false).removeList(index);
                          },
                          onItemEnableToggle: (i) => {},
                          onModifyItem: (GuardListModel item, String newName) {
                            Provider.of<GuardListsProvider>(context, listen: false)
                                .renameGuardList(item.name, newName);
                          },
                          modifyItemDialogText: "Edit List Name",
                          withEnableToggleOption: false,
                          onItemTapped: (item) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GuardListDetailScreen(guardList: item)),
                            );
                          },)
                      )),
                  ]
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GuardListsScreenBottomAppBar(
                isAppBarVisible: isAppBarVisible,
                onAddPressed: () {
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

  Widget _buildNoListWidget() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
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
    ));
  }

  Widget _buildClearButton(BuildContext context) {
  return OutlinedButton.icon(
      onPressed: () {
        _showClearConfirmationDialog(context);
      },
      icon: const Icon(Icons.recycling, size: 20.0),
      label: const Text("Clear"),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.primary), // Border color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Rounded corners
      ),
    );
}

void _showClearConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text("Are you sure you want to clear the guard list?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: const Text("Clear"),
            onPressed: () {
              Provider.of<GuardListsProvider>(context, listen: false).clearGuardLists();
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}