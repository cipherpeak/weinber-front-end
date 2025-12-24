import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

class TechnicianTaskInProgressScreen extends StatelessWidget {
  const TechnicianTaskInProgressScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= TASK INFO CARD =================
            _taskInfoCard(),

            const SizedBox(height: 24),

            /// ================= PROGRESS UPDATE =================
            Text(
              "PROGRESS UPDATE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.6,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Document your progress, observations, or any issues encountered",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 12),

            _progressInput(),
          ],
        ),
      ),

      /// ================= BOTTOM CTA =================
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              /// ================= UPDATE PROGRESS =================
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Open update progress dialog / keep user on same page
                    },
                    child: const Text(
                      "Update Progress",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// ================= END TASK =================
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      router.go(routerTechnicianTaskPage);
                    },
                    child: const Text(
                      "End Task",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }

  // =====================================================
  // TASK INFO CARD
  // =====================================================
  Widget _taskInfoCard() {
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
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "#EHK6824_34KL",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "In Progress",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            "High Pressure Machine (HP) - RE-82567",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

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
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Started at: 10:30 AM",
            style: TextStyle(
              fontSize: 12,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PROGRESS INPUT
  // =====================================================
  Widget _progressInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TEXT AREA
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add progress notes here",
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black38,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        /// CAMERA BUTTON
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
