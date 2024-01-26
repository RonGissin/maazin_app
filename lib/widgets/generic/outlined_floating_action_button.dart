import 'package:flutter/material.dart';

class OutlinedFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  OutlinedFloatingActionButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;

    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon, color: scheme.primary, size: 25),
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: scheme.primary, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
