import 'package:flutter/material.dart';
import '../outlined_floating_action_button.dart';

class GuardListsScreenBottomAppBar extends StatelessWidget {
  final bool isAppBarVisible;
  final VoidCallback onAddPressed;

  const GuardListsScreenBottomAppBar({
    Key? key,
    required this.isAppBarVisible,
    required this.onAddPressed,
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
            onPressed: onAddPressed,
            icon: Icons.add,
          )
      ];
  }
}
