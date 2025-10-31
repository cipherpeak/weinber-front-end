import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/features/TaskPage/Presentation/Screens/TodaysTask.dart';

import '../Widgets/task_card.dart';
import 'PendingTask.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          // 🔍 Search Bar
          FocusScope(
            child: Focus(
              onFocusChange: (hasFocus) {
                // You can setState() here if you want to do more on focus
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), // ✅ more rounded
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  cursorColor: const Color(0xFF5667FD),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Search by vehicle or task',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(Icons.search,
                        color: Colors.grey.shade500, size: 22),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),

                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🧾 Tabs
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
              indicatorWeight: 2.2,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(child: Text("Today's Task", style: TextStyle(fontFamily: appFont),)),
                Tab(child: Text("Pending Task",style: TextStyle(fontFamily: appFont))),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Tab Views
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today's Task Tab
                TodaysTask(),

                // Pending Task Tab
                PendingTask(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
