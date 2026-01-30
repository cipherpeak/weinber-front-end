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
  String statusOfDelivery = "";

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
            onPressed: () {
              router.push(
                routerDeliveryTaskCompletePage,
                extra: widget.taskId,
              );
            },
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


  // ================= HELPERS =================



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
