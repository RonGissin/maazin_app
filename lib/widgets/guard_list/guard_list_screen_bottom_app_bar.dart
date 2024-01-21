import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import '../../models/assigned_team_member.dart';
import '../../utils/snack_bar_util.dart';
import '../../utils/whatsapp_guard_list_formatter.dart';

class GuardListScreenBottomAppBar extends StatelessWidget {
  final bool isAppBarVisible;
  final List<List<AssignedTeamMember>> guardGroups;
  final VoidCallback onAddOrEditPressed;

  const GuardListScreenBottomAppBar({
    Key? key,
    required this.isAppBarVisible,
    required this.guardGroups,
    required this.onAddOrEditPressed,
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
              children: _buildFabWidgets(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFabWidgets(BuildContext context) {
    return guardGroups.isEmpty
      ? [
          FloatingActionButton(
            onPressed: onAddOrEditPressed,
            child: const Icon(Icons.add),
          ),
        ]
      : [
          FloatingActionButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: WhatsappGuardListFormatter.ListToString(guardGroups)));
              SnackbarUtil.showSnackBar(context, 'List Copied!');
            },
            child: const Icon(Icons.copy),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              final String readableList = WhatsappGuardListFormatter.ListToString(guardGroups);
              Share.share(readableList);
            },
            child: const Icon(Icons.share_sharp),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: onAddOrEditPressed,
            child: const Icon(Icons.edit),
          ),
        ];
  }
}
