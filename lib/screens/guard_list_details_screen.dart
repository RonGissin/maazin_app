import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/guard_list_model.dart';
import '../widgets/guard_list/guard_list.dart';
import '../widgets/guard_list/guard_lists_screen_bottom_app_bar.dart';

class GuardListDetailScreen extends StatefulWidget {
  final GuardListModel guardList;

  const GuardListDetailScreen({Key? key, required this.guardList}) : super(key: key);

  @override
  _GuardListDetailScreenState createState() => _GuardListDetailScreenState();
}

class _GuardListDetailScreenState extends State<GuardListDetailScreen>
    with AutomaticKeepAliveClientMixin {
  bool isAppBarVisible = true;
  DateTime selectedStartTime = DateTime.now();
  DateTime selectedEndTime = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guardList.name),
        centerTitle: true,
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
                onAddPressed: () {
                  // Implement the functionality for the add button here
                  // Example: _showGenerateListModal(...);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Implement _showGenerateListModal or other relevant methods as needed
}
