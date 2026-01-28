import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../../../../utils/Common Functions/compressImage.dart';
import '../../Api/delivery_task_repository.dart';
import '../../Model/delivery_task_start_details_model.dart';

class DeliveryTaskStartTaskScreen extends StatefulWidget {
  final int taskId;

  const DeliveryTaskStartTaskScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<DeliveryTaskStartTaskScreen> createState() =>
      _DeliveryTaskStartTaskScreenState();
}

class _DeliveryTaskStartTaskScreenState
    extends State<DeliveryTaskStartTaskScreen> {
  final repo = DeliveryTaskRepository();

  bool loading = true;
  bool endingTask = false;

  String? error;
  DeliveryTaskStartDetails? data;

  File? selectedImage;
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStartedTask();
  }

  // ================= STARTED TASK DETAILS =================

  Future<void> _loadStartedTask() async {
    try {
      final res = await repo.fetchStartedTaskDetails(widget.taskId);

      if (!mounted) return;

      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

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
    final compressed = await compressImage(selectedImage!);
    try {
      await repo.endDeliveryTask(
        taskId: widget.taskId,
        notes: notesController.text,
        image: compressed,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Task completed successfully"),
        ),
      );
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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    }

    final t = data!;

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
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [
            _card(child: _customerCard(t)),
            const SizedBox(height: 14),
            _card(child: _taskDetailsCard(t)),
            const SizedBox(height: 90),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: endingTask ? null : () => _showEndTaskDialog(context),
            child: const Text(
              "End Task",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= CUSTOMER =================

  Widget _customerCard(DeliveryTaskStartDetails t) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFFF1F3F5),
          child: Icon(Icons.person, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.customerName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(t.customerPhone,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  // ================= TASK DETAILS =================

  Widget _taskDetailsCard(DeliveryTaskStartDetails t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Order ID : ${t.deliveryId}",
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            _statusChip(t.status),
          ],
        ),
        const SizedBox(height: 12),
        _info("Estimated Delivery Time", t.dueTime),
        _info("Location", t.location),
      ],
    );
  }

  Widget _statusChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF9800)),
      ),
    );
  }

  // ================= END TASK UI =================

  void _showEndTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Complete Task",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),

              const SizedBox(height: 14),

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
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(selectedImage!,
                      height: 120, fit: BoxFit.cover),
                ),
              ],

              const SizedBox(height: 14),

              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Add notes (optional)",
                  filled: true,
                  fillColor: const Color(0xFFF8F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                      endingTask ? null : () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: endingTask ? null : _endTask, // 🔥 block multiple taps
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: endingTask
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text("Mark as Complete"),
                    ),
                  ),

                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= HELPERS =================

  Widget _imageBox(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
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

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
