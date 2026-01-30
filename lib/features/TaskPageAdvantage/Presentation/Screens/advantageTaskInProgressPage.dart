import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../utils/Common Widgets/percentageBar.dart';
import '../../../TaskPageDax/Presentation/Provider/daxPercentageProviderInProgressPage.dart';
import '../../Api/advantage_task_repo.dart';
import '../../Model/advantage_task_start_details_model.dart';

class AdvantageTaskInProgressScreen extends ConsumerStatefulWidget {
  final int taskId;

  const AdvantageTaskInProgressScreen({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<AdvantageTaskInProgressScreen> createState() =>
      _AdvantageTaskInProgressScreenState();
}

class _AdvantageTaskInProgressScreenState
    extends ConsumerState<AdvantageTaskInProgressScreen> {
  final repo = AdvantageTaskRepository();

  bool loading = true;
  String? error;
  AdvantageTaskStartDetails? data;


  @override
  void initState() {
    super.initState();
    _loadStartedTask();
  }

  Future<void> _loadStartedTask() async {
    try {
      final res = await repo.fetchAdvantageStartedTask(widget.taskId);

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
    final progress = ref.watch(percentageProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskInfoCard(t),

            const SizedBox(height: 20),

            /// ================= TASK IMAGE =================
            if (data?.image != null) ...[
              const Text(
                "Task Image",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  data!.image!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 180,
                      alignment: Alignment.center,
                      color: Colors.grey.shade200,
                      child: const Text(
                        "Failed to load image",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

          ],
        ),
      ),

      bottomNavigationBar: t.status != "completed"
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => _showCompleteTaskDialog(context),
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
      )
          : null,
    );
  }

  // =====================================================
  // TASK INFO CARD
  // =====================================================
  Widget _taskInfoCard(AdvantageTaskStartDetails t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.detailingSite.replaceAll("_", " "),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _statusChip(t.status),
            ],
          ),

          const SizedBox(height: 8),

          Text("Category: ${t.category}",
              style: const TextStyle(fontSize: 12)),

          const SizedBox(height: 4),

          Text("Sub Service: ${t.subService}",
              style: const TextStyle(fontSize: 12)),

          const SizedBox(height: 10),

          Text(
            "Started at: ${t.startedAt.substring(0, 8)}",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final isCompleted = status == "completed";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFFC4FAD6)
            : const Color(0xFFF5EACB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll("_", " ").toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isCompleted
              ? const Color(0xFF2E7D32)
              : const Color(0xFFBFA152),
        ),
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

  void _showCompleteTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Complete Task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      // 🔹 Call complete API
                      await repo.completeAdvantageTask(widget.taskId);

                      if (!mounted) return;

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Task marked as completed"),
                        ),
                      );

                      // 🔹 Go back to task list
                      router.go(routerAdvantageTaskPage);
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },

                  child: const Text(
                    "Mark Task as Completed",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
