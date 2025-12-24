import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/TaskPageDax/Presentation/Provider/StartTask/startTaskProvider.dart';

Widget PercentageBar(Provider PercentageProgress) {
  return Consumer(
    builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final progress = ref.watch(PercentageProgress);
      return Container(
        height: 6,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.indigoAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      );
    },
  );
}
