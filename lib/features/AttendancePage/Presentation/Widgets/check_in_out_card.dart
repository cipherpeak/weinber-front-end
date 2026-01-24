import 'package:flutter/material.dart';

Widget checkInOutCard(Map<String, dynamic> task) {
  final String title = task["title"];
  final String? reason = task["reason"];

  // Define colors based on title
  Color textColor;
  Color bgColor;

  if (title.toLowerCase().contains("checked in")) {
    textColor = Colors.green.shade700;
    bgColor = Colors.green.shade50;
  } else if (title.toLowerCase().contains("checked out")) {
    textColor = Colors.red.shade700;
    bgColor = Colors.red.shade50;
  } else {
    textColor = Colors.black87;
    bgColor = Colors.grey.shade100;
  }

  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Text(
              task["time"],
              style: TextStyle(
                // fontFamily: 'Gotham',
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(topRight: Radius.circular(14), bottomRight: Radius.circular(14)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    // fontFamily: 'Gotham',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                if (reason != null && reason.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Reason: $reason",
                    style: TextStyle(
                      // fontFamily: 'Gotham',
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
