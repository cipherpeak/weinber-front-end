import 'package:flutter/material.dart';
import '../../../../core/constants/page_routes.dart';
import '../../Api/technician_task_repo.dart';
import '../../Model/technician_task_model.dart';

class TechnicianTaskScreen extends StatefulWidget {
  const TechnicianTaskScreen({super.key});

  @override
  State<TechnicianTaskScreen> createState() => _TechnicianTaskScreenState();
}

class _TechnicianTaskScreenState extends State<TechnicianTaskScreen> {
  final repo = TechnicianTaskRepository();

  bool loading = true;
  String? error;

  List<TechnicianTaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final res = await repo.fetchTechnicianTasks();
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

  List<TechnicianTaskModel> _sortedTasks(List<TechnicianTaskModel> list) {
    int rank(String status) {
      final s = status.toLowerCase();

      if (s == "not_started" || s == "not started") return 0; // top
      if (s == "completed") return 2; // bottom
      return 1; // middle (in_progress, pending, etc.)
    }

    final sorted = [...list];
    sorted.sort((a, b) => rank(a.status).compareTo(rank(b.status)));
    return sorted;
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
            const Text("Failed to load technician tasks"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadTasks,
              child: const Text("Retry"),
            )
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
                router.push(routerTechnicianCreateTaskPage);
              },
              child: _addTaskCard(),
            ),

            const SizedBox(height: 20),

            if (tasks.isNotEmpty) ...[
              Text(
                "TASK ASSIGNED",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 12),
            ],

            ..._sortedTasks(tasks).map((t) => _taskCard(t)),

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

  Widget _statusChip(String status) {
    final s = status.toLowerCase();

    Color bgColor;
    Color textColor;

    if (s == "completed"  ) {
      bgColor = const Color(0xFFC4FAD6); // light green bg
      textColor = const Color(0xFF2E7D32); // dark green text
    }else if (s == "in_progress"){
      bgColor = const Color(0xFFF6E0BF); // light grey bg
      textColor = Color(0xFFF69F1A);
    } else {
      bgColor = const Color(0xFFF8F2F2); // light grey bg
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


  // ================= TASK CARD =================

  Widget _taskCard(TechnicianTaskModel t) {
    final bgColor =
    t.status == "in_progress" ? const Color(0xFFE8F1FF) : const Color(0xFFFFF3E0);

    return GestureDetector(
      onTap: () {
        router.push(
          routerTechnicianTaskDetailsPage,
          extra: t.id, // later use for details API
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.heading ?? "Technician Task #${t.id}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${t.machineType.replaceAll('_', ' ').toUpperCase()} | Bay: ${t.bayNumber}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Site: ${t.siteNumber}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          _statusChip(t.status),

          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
        ],
      ),

      ),
    );
  }
}
