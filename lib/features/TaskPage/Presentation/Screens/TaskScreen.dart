import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../Widgets/task_card.dart';

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
                Tab(text: "Today's Task"),
                Tab(text: 'Pending Task'),
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
                Column(
                  children: [
                    TaskCard(
                      icon: Icons.local_car_wash_outlined,
                      color: iconBlue,
                      title: 'Car Wash – Sedan',
                      subtitle: 'Toyota Camry · ABC 123',
                      dueTime: '02:00 PM',
                    ),
                    const SizedBox(height: 10),
                    TaskCard(
                      icon: Icons.cleaning_services_outlined,
                      color: iconOrange,
                      title: 'Interior Detailing – SUV',
                      subtitle: 'Ford Focus · XYZ 789',
                      dueTime: '04:00 PM',
                    ),
                    const SizedBox(height: 10),
                    TaskCard(
                      icon: Icons.tire_repair_outlined,
                      color: iconGreen,
                      title: 'Tire Pressure Check',
                      subtitle: 'Honda Civic · LMN 456',
                      dueTime: '06:00 PM',
                    ),
                  ],
                ),

                // Pending Task Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.inbox_outlined,
                          size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'No Pending Tasks',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
