import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';
import 'package:weinber/features/Homepage/Presentation/Provider/home_notifier.dart';

import '../../../TaskPageOffice/Model/technician_task_details_model.dart';
import '../../Api/technician_task_repo.dart';

class TechnicianTaskDetailsScreen extends ConsumerStatefulWidget {
  final int taskId;

  const TechnicianTaskDetailsScreen({super.key, required this.taskId});

  @override
  ConsumerState<TechnicianTaskDetailsScreen> createState() =>
      _TechnicianTaskDetailsScreenState();
}

class _TechnicianTaskDetailsScreenState
    extends ConsumerState<TechnicianTaskDetailsScreen> {
  final repo = TechnicianTaskRepository();

  bool loading = true;
  String? error;
  TechnicianTaskDetails? data;
  bool starting = false;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }



  Future<void> _startTask() async {
    setState(() => starting = true);

    try {
      await repo.startTechnicianTask(widget.taskId);

      ref.read(homeNotifierProvider.notifier).refresh();
      router.push(
        routerTechnicianTaskInProgressPage,
        extra: widget.taskId,
      );

    } catch (e) {
      final msg = e.toString().toLowerCase();

      // if backend says already started
      if (msg.contains("already")) {
        router.push(
          routerTechnicianTaskInProgressPage,
          extra: widget.taskId,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => starting = false);
    }
  }


  Future<void> _loadDetails() async {
    try {
      final res = await repo.fetchTechnicianTaskDetails(widget.taskId);
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Task Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: _taskDetailsCard(t),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            onPressed: starting
                ? null
                : () {
              if (t.status == "not_started") {
                _startTask(); // API
              } else {
                router.push(
                  routerTechnicianTaskInProgressPage,
                  extra: widget.taskId,
                );
              }
            },
            child: starting
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
              t.status == "not_started" ? "Start Task" : "View Task",
              style: const TextStyle(
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

  Widget _taskDetailsCard(TechnicianTaskDetails t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.heading ?? "Technician Task",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 6),

          Text(
            "${t.machineType.replaceAll('_', ' ').toUpperCase()} - ${t.machineSerialNumber}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                "Site: ${t.siteNumber} | Bay: ${t.bayNumber}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Spare Part: ${t.sparePartDetails}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 6),

          Text(
            "Quantity: ${t.quantity}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 16),

          const Text(
            "Job Description",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              t.jobDescription,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
