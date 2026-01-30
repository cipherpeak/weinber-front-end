import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';
import '../../../../utils/Common Functions/compressImage.dart';
import '../../../Homepage/Presentation/Provider/home_notifier.dart';
import '../../Api/delivery_task_repository.dart';

class DeliveryTaskCompleteScreen extends ConsumerStatefulWidget {
  final int taskId;


  const DeliveryTaskCompleteScreen({
    super.key,
    required this.taskId,

  });

  @override
  ConsumerState<DeliveryTaskCompleteScreen> createState() =>
      _DeliveryTaskCompleteScreenState();
}

class _DeliveryTaskCompleteScreenState
    extends ConsumerState<DeliveryTaskCompleteScreen> {

  final List<String> deliveryStatuses = [
    "completed",
    "rejected",
    "returned",
    "cancelled",
  ];


  final repo = DeliveryTaskRepository();

  File? selectedImage;
  final notesController = TextEditingController();
  bool endingTask = false;
  String statusOfDelivery = "";



  // ================= IMAGE PICK =================

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 70);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  // ================= END TASK =================

  Future<void> _endTask() async {

    if (statusOfDelivery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please select delivery status"),
        ),
      );
      return;
    }

    if (endingTask) return;

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please upload task completion image"),
        ),
      );
      return;
    }

    setState(() => endingTask = true);

    final compressed =
    selectedImage != null ? await compressImage(selectedImage!) : null;


    try {
      await repo.endDeliveryTask(
        taskId: widget.taskId,
        notes: notesController.text,
        image: compressed!,
        statusOfDelivery: statusOfDelivery,
      );

      // ✅ refresh home
      ref.read(homeNotifierProvider.notifier).refresh();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Task completed successfully"),
        ),
      );

      // ✅ go back to task list
      router.go(routerDeliveryTaskPage);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) setState(() => endingTask = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Complete Task",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Upload Completion Image",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            Row(
              children: [
                _imageBox(Icons.camera_alt, "Camera",
                        () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 12),
                _imageBox(Icons.photo_library, "Gallery",
                        () => _pickImage(ImageSource.gallery)),
              ],
            ),

            if (selectedImage != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(selectedImage!,
                    height: 160, width: double.infinity, fit: BoxFit.cover),
              ),
            ],

            const SizedBox(height: 20),

            const Text(
              "Delivery Status",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: statusOfDelivery.isEmpty ? null : statusOfDelivery,
                  hint: const Text(
                    "Select delivery status",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  isExpanded: true,
                  items: deliveryStatuses
                      .map(
                        (status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      statusOfDelivery = value!;
                    });
                  },
                ),
              ),
            ),


            const Text("Notes (optional)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add notes about delivery",
                filled: true,
                fillColor: const Color(0xFFF1F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: endingTask ? null : _endTask,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
            ),
            child: endingTask
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : const Text(
              "Mark as Complete",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _imageBox(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: primaryColor),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
