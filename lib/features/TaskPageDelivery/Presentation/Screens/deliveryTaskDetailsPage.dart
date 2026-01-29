import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';
import '../../../Homepage/Presentation/Provider/home_notifier.dart';
import '../../Api/delivery_task_repository.dart';
import '../../Model/delivery_task_details_model.dart';

class DeliveryTaskDetailsScreen extends ConsumerStatefulWidget {
  final int taskId;
  final bool isCompleted;
  final String status;

  const DeliveryTaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.isCompleted,
    required this.status,
  });

  @override
  ConsumerState<DeliveryTaskDetailsScreen> createState() =>
      _DeliveryTaskDetailsScreenState();
}


class _DeliveryTaskDetailsScreenState extends ConsumerState<DeliveryTaskDetailsScreen> {
  final repo = DeliveryTaskRepository();
  bool get isNotStarted =>
      widget.status.toLowerCase() == "not_started" ||
          widget.status.toLowerCase() == "not started";


  bool loading = true;
  String? error;
  DeliveryTaskDetails? data;
  bool startingTask = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final res = await repo.fetchDeliveryTaskDetails(widget.taskId);
      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }
  Future<void> _startTask() async {
    setState(() => startingTask = true);

    try {
      await repo.startDeliveryTask(taskId: widget.taskId);

// ✅ refresh home data
      ref.read(homeNotifierProvider.notifier).refresh();

// ✅ navigate
      router.push(
        routerDeliveryTaskStartTaskPage,
        extra: widget.taskId,
      );


    } catch (e) {
      // final msg = e.toString().toLowerCase();
      //
      // if (msg.contains("already in progress")) {
      //   // 🟡 Task already started → just open started task page
      //   router.push(
      //     routerDeliveryTaskStartTaskPage,
      //     extra: widget.taskId,
      //   );
      //   return;
      // }

      // 🔴 Real error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );

    } finally {
      if (mounted) setState(() => startingTask = false);
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
        title: const Text(
          "Task Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          children: [

            /// CUSTOMER CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: _cardDecoration(),
              child: Row(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.call, size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text("Call",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// DETAILS
            _detailsCard(t),

            const SizedBox(height: 14),

            _infoBlock("Delivery Notes", t.notes),

            const SizedBox(height: 14),

            _infoBlock(
              "Task Priority",
              t.priority.toUpperCase(),
              color: Colors.red,
              bold: true,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: widget.isCompleted
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            onPressed: startingTask
                ? null
                : () {
              if (isNotStarted) {
                _startTask(); // ▶ start API
              } else {
                // ▶ directly open started task page
                router.push(
                  routerDeliveryTaskStartTaskPage,
                  extra: widget.taskId,
                );
              }
            },
            child: startingTask
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              isNotStarted ? "Start Task" : "View Task",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),

        ),
      ),

    );
  }

  Widget _detailsCard(DeliveryTaskDetails t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Order ID", t.deliveryId),
          _infoRow("Estimated Time", t.dueTime),
          _infoRow("Location", t.location),
        ],
      ),
    );
  }

  Widget _infoBlock(String title, String value,
      {Color? color, bool bold = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color ?? Colors.black54,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
