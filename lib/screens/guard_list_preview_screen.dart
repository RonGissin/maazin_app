import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/guard_list_model.dart';
import '../widgets/guard_list/guard_list.dart';
import '../widgets/guard_list/guard_lists_screen_bottom_app_bar.dart';

class GuardListPreviewScreen extends StatefulWidget {
  final GuardListModel guardList;
  final VoidCallback onSave;
  final VoidCallback onRegenerate;

  GuardListPreviewScreen({
    Key? key,
    required this.guardList,
    required this.onSave,
    required this.onRegenerate,
  }) : super(key: key);

  @override
  _GuardListPreviewScreenState createState() => _GuardListPreviewScreenState();
}

class _GuardListPreviewScreenState extends State<GuardListPreviewScreen> {
  bool isAppBarVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: ${widget.guardList.name}'),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          setState(() {
            if (notification.direction == ScrollDirection.reverse) {
              isAppBarVisible = false;
            } else if (notification.direction == ScrollDirection.forward) {
              isAppBarVisible = true;
            }
          });
          return true;
        },
        child: Stack(
          children: [
            GuardList(name: widget.guardList.name, guardGroups: widget.guardList.guardGroups),
            Align(
              alignment: Alignment.bottomCenter,
              child: GuardListsScreenBottomAppBar(
                isAppBarVisible: isAppBarVisible,
                onAddPressed: widget.onSave, // Assuming this should trigger onSave
                // Add any additional buttons or functionality you need
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: widget.onSave,
      ),
    );
  }
}