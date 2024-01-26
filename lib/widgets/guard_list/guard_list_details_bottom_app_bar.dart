import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maazin_app/models/guard_list_model.dart';
import 'package:share/share.dart';
import '../../utils/snack_bar_util.dart';
import '../../utils/whatsapp_guard_list_formatter.dart';
import '../generic/outlined_floating_action_button.dart';

class GuardListDetailsBottomAppBar extends StatelessWidget {
  final bool isAppBarVisible;
  final GuardListModel guardList;

  const GuardListDetailsBottomAppBar({
    Key? key,
    required this.isAppBarVisible,
    required this.guardList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isAppBarVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomAppBar(
          notchMargin: 4.0,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildFabWidgets(context, guardList),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFabWidgets(BuildContext context, GuardListModel guardList) {
    return [
          OutlinedFloatingActionButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: WhatsappGuardListFormatter.ListToString(guardList.guardGroups)));
              SnackbarUtil.showSnackBar(context, 'List Copied!');
            },
            icon: Icons.copy,
          ),
          const SizedBox(width: 10),
          OutlinedFloatingActionButton(
            onPressed: () {
              final String readableList = WhatsappGuardListFormatter.ListToString(guardList.guardGroups);
              Share.share(readableList);
            },
            icon: Icons.share_sharp,
          ),
      ];
  }
}
