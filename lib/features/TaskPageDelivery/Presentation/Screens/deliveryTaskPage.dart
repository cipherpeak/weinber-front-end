import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';
import '../../Api/delivery_task_repository.dart';
import '../../Model/delivery_task_model.dart';

class DeliveryTaskScreen extends StatefulWidget {
  const DeliveryTaskScreen({super.key});

  @override
  State<DeliveryTaskScreen> createState() => _DeliveryTaskScreenState();
}

class _DeliveryTaskScreenState extends State<DeliveryTaskScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  final repo = DeliveryTaskRepository();

  bool loading = true;
  String? error;

  List<DeliveryTaskModel> todayTasks = [];
  List<DeliveryTaskModel> pendingTasks = [];
  List<DeliveryTaskModel> completedTasks = [];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final res = await repo.fetchDeliveryTasks();

      setState(() {
        todayTasks = res.todayTasks;
        pendingTasks = res.pendingTasks;
        completedTasks = res.completedTasks; // ✅
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
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Tasks Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: appFont,
              ),
            ),

            const SizedBox(height: 14),

            _searchBar(),

            const SizedBox(height: 14),

            _tabs(),

            const SizedBox(height: 12),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _todayWithCompleted(), // ✅ today + completed
                  _taskList(pendingTasks),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _todayWithCompleted() {
    if (todayTasks.isEmpty && completedTasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return ListView(
      children: [

        /// 🔵 TODAY TASKS
        if (todayTasks.isNotEmpty)
          ...todayTasks.map((t) => GestureDetector(
            onTap: () {
              router.push(
                routerDeliveryTaskDetailsPage,
                extra: {
                  "id": t.id,
                  "isCompleted": false,
                },
              );
            },
            child: _taskCard(
              taskId: t.deliveryId,
              from: t.customerName,
              address: t.location,
              isHighPriority: t.isHighPriority,
            ),
          )),

        /// 🟢 COMPLETED SECTION
        if (completedTasks.isNotEmpty) ...[
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              "COMPLETED TASKS",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          ...completedTasks.map((t) => GestureDetector(
            onTap: () {
              router.push(
                routerDeliveryTaskDetailsPage,
                extra: {
                  "id": t.id,
                  "isCompleted": true,
                },
              );
            },
            child: _taskCard(
              taskId: t.deliveryId,
              from: t.customerName,
              address: t.location,
              isHighPriority: false,
            ),
          )),
        ],

        const SizedBox(height: 10),
      ],
    );
  }


  // ---------------- UI PARTS ----------------

  Widget _searchBar() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search by vehicle or task",
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: primaryColor,
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(text: "Today's Task"),
        Tab(text: "Pending Task"),
      ],
    );
  }

  Widget _taskList(List<DeliveryTaskModel> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No tasks found"));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];

        return GestureDetector(
          onTap: () {
            router.push(
              routerDeliveryTaskDetailsPage,
              extra: {
                "id": t.id,
                "isCompleted": false,
              },
            );
          },
          child: _taskCard(
            taskId: t.deliveryId,
            from: t.customerName,
            address: t.location,
            isHighPriority: t.isHighPriority,
          ),
        );
      },
    );
  }


  // =====================================================
  // TASK CARD
  // =====================================================
  Widget _taskCard({
    required String taskId,
    required String from,
    required String address,
    bool isHighPriority = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ID + PRIORITY
                Row(
                  children: [
                    Text(
                      "ID: $taskId",
                      style: const TextStyle(
                        fontFamily: appFont,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isHighPriority) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "High Priority",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "From: $from",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontFamily: appFont,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Address: $address",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontFamily: appFont,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT ARROW
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
