import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 34.0),
          child: Center(child: Text(message)),
        ),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      behavior: SnackBarBehavior.fixed,
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),    
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
