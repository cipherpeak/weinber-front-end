import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/page_routes.dart';
import '../../Api/advantage_task_repo.dart';
import '../../Model/advantage_task_details_model.dart';

class AdvantageTaskDetailsScreen extends StatefulWidget {
  final int taskId;
  final String status;

  const AdvantageTaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.status,
  });

  @override
  State<AdvantageTaskDetailsScreen> createState() =>
      _AdvantageTaskDetailsScreenState();
}

class _AdvantageTaskDetailsScreenState
    extends State<AdvantageTaskDetailsScreen> {
  final repo = AdvantageTaskRepository();

  bool loading = true;
  String? error;
  AdvantageTaskDetails? data;
  String? fullUrl;
  bool startingTask = false;

  bool get isNotStarted => widget.status == "not_started";

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final res = await repo.fetchAdvantageTaskDetails(widget.taskId);
      setState(() {
        data = res;
        fullUrl = res.image != null
            ? "${ApiEndpoints.mediaBaseUrl}${res.image}"
            : null;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _onPrimaryAction() async {
    /// CASE 1: NOT STARTED → CALL START API
    if (isNotStarted) {
      if (startingTask) return;

      setState(() => startingTask = true);

      try {
        await repo.startAdvantageTask(widget.taskId);

        if (!context.mounted) return;

        router.push(
          routerAdvantageTaskInProgressPage,
          extra: widget.taskId,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(e.toString()),
          ),
        );
      } finally {
        if (mounted) setState(() => startingTask = false);
      }
    }

    /// CASE 2: ALREADY STARTED / COMPLETED → JUST VIEW
    else {
      router.push(
        routerAdvantageTaskInProgressPage,
        extra: widget.taskId,
      );
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: _detailsCard(t),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
               primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: startingTask ? null : _onPrimaryAction,
            child: startingTask
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : Text(
              isNotStarted ? "Start Task" : "View Task",
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

  // =====================================================
  // DETAILS CARD
  // =====================================================

  Widget _detailsCard(AdvantageTaskDetails t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.detailingSite.replaceAll("_", " "),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),

          Text("Category : ${t.category}",
              style: const TextStyle(fontSize: 13)),

          const SizedBox(height: 4),

          Text("Sub Service : ${t.subService}",
              style: const TextStyle(fontSize: 13)),

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
              t.plu,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),

          if (fullUrl != null) ...[
            const SizedBox(height: 20),
            const Text(
              "Task Image",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                fullUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
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
        ),
      ],
    );
  }
}
