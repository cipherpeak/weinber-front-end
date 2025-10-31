import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/utils/Common%20Widgets/percentageBar.dart';

import '../Provider/StartTask/startTaskProvider.dart';

class PendingTaskWithProgressCard extends StatelessWidget {
  const PendingTaskWithProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(.3),
            // spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Morning Vehicle Inspection",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Toyota Camry - ABC 123',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Text(
                'Task Assigned - Yesterday',
                style: const TextStyle(fontSize: 11, color: Colors.redAccent),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(alignment: AlignmentGeometry.centerRight,
            child: const Text(
              '85% Completed',
              style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PercentageBar(saveProgressPercentageProvider), // example with 85%
              ),


            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: primaryColor),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,),
                  ),
                  child: const Text('Mark as Complete', style: TextStyle(color:  primaryColor),),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Continue Task', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
