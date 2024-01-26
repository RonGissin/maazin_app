
import 'package:flutter/material.dart';
import '../models/guard_list_model.dart';
import '../widgets/guard_list/guard_list.dart';
import '../widgets/guard_list/guard_lists_screen_bottom_app_bar.dart';

class GuardListDetailScreen extends StatefulWidget {
  const GuardListDetailScreen({Key? key}) : super(key: key);

  @override
  _GuardListDetailScreenState createState() => _GuardListDetailScreenState();
}

class _GuardListDetailScreenState extends State<GuardListDetailScreen>
    with AutomaticKeepAliveClientMixin {
  final GuardListModel guardList;

  GuardListDetailScreen({Key? key, required this.guardList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guardList.name),
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
            GuardList(name: guardList.name, guardGroups: guardList.guardGroups),
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
  }
}
