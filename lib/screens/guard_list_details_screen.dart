import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/guard_list_model.dart';
import '../widgets/guard_list/guard_list.dart';
import '../widgets/guard_list/guard_list_details_bottom_app_bar.dart';

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
            GuardList(
              keyPrefix: 'guard-list-details',
              name: widget.guardList.name,
              guardGroups: widget.guardList.guardGroups,
              saveListOnReorder: true,),
            Align(
              alignment: Alignment.bottomCenter,
              child: GuardListDetailsBottomAppBar(
                guardList: widget.guardList,
                isAppBarVisible: isAppBarVisible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
