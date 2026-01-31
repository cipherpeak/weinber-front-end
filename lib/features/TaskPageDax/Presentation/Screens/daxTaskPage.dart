import 'package:flutter/material.dart';
import '../../../../core/constants/page_routes.dart';
import '../../Api/dax_task_repository.dart';
import '../../Model/dax_task_model.dart';

class DaxTaskScreen extends StatefulWidget {
  const DaxTaskScreen({super.key});

  @override
  State<DaxTaskScreen> createState() => _DaxTaskScreenState();
}

class _DaxTaskScreenState extends State<DaxTaskScreen> {
  final repo = DaxTaskRepository();

  bool loading = true;
  String? error;
  List<DaxTaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final res = await repo.fetchDaxTasks();
      setState(() {
        tasks = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst("Exception: ", "");
        loading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Tasks Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                router.push(routerDaxCreateTaskPage);
              },
              child: _addTaskCard(),
            ),
            const SizedBox(height: 22),
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
          Text("Add New Task",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _taskCard(DaxTaskModel t) {
    return GestureDetector(
      onTap: () {
        router.push(
          routerDaxTaskDetailsPage,
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.serviceName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        t.detailingSite.replaceAll("_", " "),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _statusChip(t.status),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final s = status.toLowerCase();

    Color bg;
    Color text;

    if (s == "completed") {
      bg = const Color(0xFFC8E6C9);
      text = const Color(0xFF2E7D32);
    } else if (s == "in_progress") {
      bg = const Color(0xFFFFF3CD);
      text = const Color(0xFFF57C00);
    } else {
      bg = const Color(0xFFF1F3F5);
      text = Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.replaceAll("_", " ").toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}


