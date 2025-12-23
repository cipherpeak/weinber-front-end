import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';

class DeliveryTaskScreen extends StatefulWidget {
  const DeliveryTaskScreen({super.key});

  @override
  State<DeliveryTaskScreen> createState() => _DeliveryTaskScreenState();
}

class _DeliveryTaskScreenState extends State<DeliveryTaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ============================
            /// TITLE
            /// ============================
            const Text(
              "Tasks Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: appFont,
              ),
            ),

            const SizedBox(height: 14),

            /// ============================
            /// SEARCH BAR
            /// ============================
            Container(
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
                cursorColor: primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search by vehicle or task",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                    fontFamily: appFont,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// ============================
            /// TABS
            /// ============================
            TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: appFont,
              ),
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: "Today's Task"),
                Tab(text: "Pending Task"),
              ],
            ),

            const SizedBox(height: 12),

            /// ============================
            /// TAB VIEWS
            /// ============================
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _todayTasks(),
                  _pendingTasks(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TODAY TASKS
  // =====================================================
  Widget _todayTasks() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        GestureDetector(onTap: (){
          router.push(routerDeliveryTaskDetailsPage);
        },
          child: _taskCard(
            taskId: "#8B342-A",
            from: "Jane Doe",
            address: "123 Main Street, Anytown",
            isHighPriority: true,
          ),
        ),
        _taskCard(
          taskId: "#7637G-M",
          from: "John Smith",
          address: "456 Oak Avenue, Sometown",
        ),
        _taskCard(
          taskId: "#7545Q2-4P",
          from: "Emily White",
          address: "789 Pine Lane, Otherville",
        ),
      ],
    );
  }

  // =====================================================
  // PENDING TASKS
  // =====================================================
  Widget _pendingTasks() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _taskCard(
          taskId: "#1122X-A",
          from: "Vendor ABC",
          address: "Warehouse Road, Industrial Area",
        ),
      ],
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
