// ---------------- Reusable Widgets ----------------
import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class TaskHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Car Wash – Sedan",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Toyota Camry - ABC 123",
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                "02:00 PM",
                style: TextStyle( fontSize: 13),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFF5E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "In Progress",
                  style: TextStyle(
                    color: Color(0xffE19B34),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}