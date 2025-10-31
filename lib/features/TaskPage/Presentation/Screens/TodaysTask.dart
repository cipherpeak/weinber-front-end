import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../Widgets/task_card.dart';

class TodaysTask extends StatelessWidget {
  const TodaysTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        const SizedBox(height: 10),
        TaskCard(
          icon: Icons.tire_repair_outlined,
          color: iconGreen,
          title: 'Tire Pressure Check',
          subtitle: 'Honda Civic · LMN 456',
          dueTime: '06:00 PM',
        ),
      ],
    );
  }
}
