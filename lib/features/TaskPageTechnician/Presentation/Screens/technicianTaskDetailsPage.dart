import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

class TechnicianTaskDetailsScreen extends StatelessWidget {
  const TechnicianTaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: _taskDetailsCard(),
      ),

      /// ================= BOTTOM BUTTON =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            onPressed: () {
              router.push(routerTechnicianTaskInProgressPage);
            },
            child: const Text(
              "Start Task",
              style: TextStyle(
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

  /// ================= MAIN CARD =================
  Widget _taskDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "#EHK6824_34KL",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 6),

          /// MACHINE INFO
          const Text(
            "High Pressure Machine (HP) - RE-82567",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          /// BAY NUMBER
          Row(
            children: const [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.black54,
              ),
              SizedBox(width: 6),
              Text(
                "Bay No: Eg3656",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// SPARE PARTS
          const Text(
            "Spare Parts: Example123",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          /// QUANTITY
          const Text(
            "Quantity: 5",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          /// JOB DESCRIPTION LABEL
          const Text(
            "Job Description",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          /// JOB DESCRIPTION BOX
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Text(
            "Inspect the high pressure machine for any leaks or abnormal noise. "
                "Perform routine maintenance checks, clean critical components, "
                "and replace the identified spare part to ensure smooth operation "
                "before restarting the machine.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ),


        ],
      ),
    );
  }
}
