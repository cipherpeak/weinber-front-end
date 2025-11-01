import 'package:flutter/material.dart';

Widget buildLabelledField({
  required String label,
  required Widget child,
  bool required = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14
          ),
          children: required
              ? const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ]
              : [],
        ),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}
