import 'package:flutter/material.dart';

showMessage({
  required BuildContext context,
  required String message,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Text(message),
    ),
  );
}
