import 'package:flutter/material.dart';
import '../generic/outlined_floating_action_button.dart';

class GuardListPreviewBottomAppBar extends StatelessWidget {
  final bool isAppBarVisible;
  final VoidCallback onSavePressed;
  final VoidCallback onShufflePressed;

  const GuardListPreviewBottomAppBar({
    Key? key,
    required this.isAppBarVisible,
    required this.onSavePressed,
    required this.onShufflePressed
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
    return [
          OutlinedFloatingActionButton(
            onPressed: onSavePressed,
            icon: Icons.save,
          ),
          SizedBox(width: 10),
          OutlinedFloatingActionButton(
            onPressed: onShufflePressed,
            icon: Icons.change_circle_rounded,
          )
      ];
  }
}
