import 'package:flutter/material.dart';

const Duration _defaultDuration = Duration(milliseconds: 4000);

extension ContextExtensions on BuildContext {
  void showRawSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  // snackbar for error
  void showErrorSnackBar(String message, {Duration duration = _defaultDuration}) {
    showRawSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red, duration: duration),
    );
  }

  // snackbar for success
  void showSuccessSnackBar(String message) {
    showRawSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  // snackbar for info
  void showSnackBar(String message) {
    showRawSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.grey));
  }
}
