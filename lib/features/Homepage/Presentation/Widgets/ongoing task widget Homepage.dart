import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/utils/Common%20Widgets/percentageBar.dart';

import '../../../TaskPage/Presentation/Provider/StartTask/startTaskProvider.dart';



class OngoingTaskWidgetHomepage extends StatelessWidget {
  const OngoingTaskWidgetHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffe4e9ff),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ONGOING TASK",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Car Wash - Sedan',
                  style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Paused',
                    style: TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '125 Main Street : 10:00 AM',
            style: const TextStyle(fontSize: 9, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Align(alignment: AlignmentGeometry.centerRight,
            child: const Text(
              '15% Completed',
              style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w500),
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
        ],
      ),
    );
  }
}
