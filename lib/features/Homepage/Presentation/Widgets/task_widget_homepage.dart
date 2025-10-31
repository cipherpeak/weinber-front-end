// Task Card
import 'package:flutter/material.dart';

Widget taskCard({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.08),
          blurRadius: 8,

          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.black45),
      ],
    ),
  );
}