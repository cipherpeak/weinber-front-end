import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';
import '../../../../utils/Common Functions/picImage.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../Provider/StartTask/pic image provider.dart';
import '../Provider/StartTask/startTaskProvider.dart';
import '../Widgets/startTaskCheckBoxTile.dart';
import 'dart:async';

import '../Widgets/startTaskHeaderCard.dart';

class StartTaskDetailsScreen extends ConsumerWidget {
  const StartTaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final parentContext = context;
    final tasks = ref.watch(taskListProvider);
    final progress = ref.watch(progressProvider);

    final areAllTasksCompleted = tasks.every((task) => task.isCompleted);
    final isAnyTaskChecked = tasks.any((task) => task.isCompleted);
    final completedPercent = (progress * 100).toStringAsFixed(0);
    final pickedImages = ref.watch(pickedImagesProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                // Handle "Take Break" tap
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Take Break",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.pause, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(bottom: true,
        child: Padding(
          // This SafeArea is redundant if AppBar is used, but kept for safety.
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Task Card ---
                TaskHeaderCard(),

                const SizedBox(height: 20),

                // --- Progress Bar ---
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    "$completedPercent% Completed",
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey,
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
                ),

                const SizedBox(height: 24),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: // --- Checklist ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final item = tasks[index];
                        return TaskCheckboxTile(
                          task: item,
                          onChanged: (_) =>
                              ref.read(taskListProvider.notifier).toggleTask(index),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200,
                        height: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- Progress Update Field ---
                const Text(
                  "PROGRESS UPDATE",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Document your progress, observations or any issues encountered",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 10
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: const TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "Add progress notes here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        // Allow picking multiple images
                        final List<XFile> images = await picker.pickMultiImage(
                          imageQuality: 80, // Optional: to reduce file size
                        );
                        if (images.isNotEmpty) {
                          ref.read(pickedImagesProvider.notifier).addImages(images);
                        }
                      },
                      child: Container(
                        height: 50,width: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                if (pickedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pickedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(pickedImages[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => ref.read(pickedImagesProvider.notifier).removeImage(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],


                const SizedBox(height: 30),

                // --- Save Progress Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isAnyTaskChecked
                        ? () {
                            if (areAllTasksCompleted) {
                              showDialog(
                                context: context,
                                builder: (BuildContext Context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    title: const Text(
                                      'Complete Task',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            'Final Comments (Optional)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const TextField(
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                            hintText: 'Add any final notes about the completed task',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Task Ready For Completion',style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontSize: 10,fontWeight: FontWeight.bold
                                          )),
                                              SizedBox(height: 8),
                                              Text(
                                                'All requires checklist items have been completed.\nThe task will be marked as finished',
                                                style: TextStyle(
                                                  color: Colors.green.shade800,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          _buildCompleteButton(Context, ref),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25),
                                                  side: BorderSide(color: Colors.grey.shade300),
                                                ),
                                              ),
                                              child: const Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 13)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                  );
                                },
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAnyTaskChecked ? primaryColor : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: areAllTasksCompleted
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Mark as Complete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_outline_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          )
                        : const Text(
                            "Save Progress",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.go(routerTaskPage);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mark as Completed",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.check_circle_outline_outlined, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

