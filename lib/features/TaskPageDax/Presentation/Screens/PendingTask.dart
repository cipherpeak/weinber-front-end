import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../Widgets/pending_task_with_progress_card.dart';
import '../Widgets/task_card.dart';

class PendingTask extends StatelessWidget {
  const PendingTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PendingTaskWithProgressCard(),
        ),
        SizedBox(height: 25,),
        Text('PENDING QUEUE', style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),),
        SizedBox(height: 20),
        TaskCard(
          icon: Icons.local_car_wash_outlined,
          color: iconBlue,
          title: 'Car Wash – Sedan',
          subtitle: 'Toyota Camry · ABC 123',
          dueTime: '02:00 PM',
        ),
        const SizedBox(height: 10),
        TaskCard(
          icon: Icons.cleaning_services_outlined,
          color: iconOrange,
          title: 'Interior Detailing – SUV',
          subtitle: 'Ford Focus · XYZ 789',
          dueTime: '04:00 PM',
        ),
      ],
    );
  }
}
