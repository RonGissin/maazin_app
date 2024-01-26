import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maazin_app/widgets/guard_list/guard_list_preview_bottom_app_bar.dart';
import '../models/generate_list_metadata.dart';
import '../models/guard_list_model.dart';
import '../widgets/guard_list/guard_list.dart';

class GuardListPreviewScreen extends StatefulWidget {
  final GuardListModel guardList;
  final VoidCallback onSave;
  final void Function(GuardListModel) onShuffle;
  final GenerateListMetadata generateListMetadata;

  GuardListPreviewScreen({
    Key? key,
    required this.guardList,
    required this.onSave,
    required this.onShuffle,
    required this.generateListMetadata
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
              keyPrefix: 'guard-list-preview',
              name: widget.guardList.name,
              guardGroups: widget.guardList.guardGroups,
              saveListOnReorder: false),
            Align(
              alignment: Alignment.bottomCenter,
              child: GuardListPreviewBottomAppBar(
                guardList: widget.guardList,
                isAppBarVisible: isAppBarVisible,
                onSavePressed: () {
                  widget.onSave();
                  Navigator.pop(context);
                  Navigator.pop(context);

                  },
                onShufflePressed: (guardList) {
                  widget.onShuffle(guardList);
                  setState(() {});
                }, 
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}