import 'package:flutter/material.dart';
import '../../../../core/constants/page_routes.dart';

import '../../Api/advantage_task_repo.dart';
import '../../Model/advantage_task_model.dart';

class AdvantageTaskScreen extends StatefulWidget {
  const AdvantageTaskScreen({super.key});

  @override
  State<AdvantageTaskScreen> createState() => _AdvantageTaskScreenState();
}

class _AdvantageTaskScreenState extends State<AdvantageTaskScreen> {
  final repo = AdvantageTaskRepository();

  bool loading = true;
  String? error;
  List<AdvantageTaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final res = await repo.fetchAdvantageTasks();
      setState(() {
        tasks = res;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Tasks Summary",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Failed to load tasks"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadTasks,
              child: const Text("Retry"),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= ADD NEW TASK =================
            GestureDetector(
              onTap: () {
                router.push(routerAdvantageCreateTaskPage);
              },
              child: _addTaskCard(),
            ),

            const SizedBox(height: 22),

            if (tasks.isNotEmpty)
              Text(
                "TASK CREATED BY YOU",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.6,
                ),
              ),

            const SizedBox(height: 12),

            ...tasks.map(_taskCard),
          ],
        ),
      ),
    );
  }

  // ================= ADD TASK CARD =================

  Widget _addTaskCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 14,
            backgroundColor: Colors.black,
            child: Icon(Icons.add, size: 16, color: Colors.white),
          ),
          SizedBox(width: 12),
          Text(
            "Add New Task",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ================= TASK CARD =================

  Widget _statusChip(String status) {
    final s = status.toLowerCase();

    Color bgColor;
    Color textColor;

    if (s == "completed") {
      bgColor = const Color(0xFFC8E6C9); // light green
      textColor = const Color(0xFF2E7D32); // dark green
    } else if (s == "in_progress") {
      bgColor = const Color(0xFFFFF3CD); // light yellow
      textColor = const Color(0xFFF57C00); // orange
    } else {
      bgColor = const Color(0xFFF1F3F5); // light grey
      textColor = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll("_", " ").toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }


  Widget _taskCard(AdvantageTaskModel t) {
    return GestureDetector(
      onTap: () {
        router.push(
          routerAdvantageTaskDetailsPage,
          extra: {
            "taskId": t.id,
            "status": t.status,
          },
        );

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEED9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LEFT CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style:
                      const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: "Detailing site: ",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: t.detailingSite.replaceAll("_", " "),
                          style:
                          const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                          children: [
                            const TextSpan(
                              text: "Category : ",
                              style:
                              TextStyle(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: t.category,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// STATUS CHIP
            _statusChip(t.status),

            const SizedBox(width: 6),

            /// ARROW
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
