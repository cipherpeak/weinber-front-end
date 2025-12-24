import 'package:flutter/material.dart';

import '../../../../core/constants/page_routes.dart';

class TechnicianTaskScreen extends StatelessWidget {
  const TechnicianTaskScreen({super.key});

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

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= ADD NEW TASK =================
            GestureDetector(
              onTap: () {
                router.push(routerTechnicianCreateTaskPage);
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                      child: Icon(Icons.add,
                          size: 16, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Add New Task",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= TASK ASSIGNED LABEL =================
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

            /// ================= TASK CARD =================
            GestureDetector(
              onTap: () {
                // Navigate to Technician Task Details
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEAFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    /// LEFT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Preventive Maintenance Tasks",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "High Pressure Machine (HP)",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Site: 08 | Bay: 02 • 10:00 AM",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT ARROW
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ================= SECOND TASK CARD =================
            GestureDetector(
              onTap: () {
                router.push(routerTechnicianTaskDetailsPage);
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEED9), // peach background
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    /// LEFT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "#EHK6824_34KL",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "High Pressure Machine (HP) | Bay No: 65467",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT ARROW
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
