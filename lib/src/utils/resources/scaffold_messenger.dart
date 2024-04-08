import 'package:flutter/material.dart';

class Messenger {
  final BuildContext context;

  Messenger(this.context);

  void showSnackBar(String message,
      {Duration duration = const Duration(seconds: 4),
      bool isFloating = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: isFloating ? SnackBarBehavior.floating : null,
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        content: Text(
          message,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
