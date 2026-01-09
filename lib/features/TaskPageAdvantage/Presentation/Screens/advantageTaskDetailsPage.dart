import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';

class AdvantageTaskDetailsScreen extends StatelessWidget {
  const AdvantageTaskDetailsScreen({super.key});

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
        child: _detailsCard(),
      ),

      /// ================= BOTTOM CTA =================
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
              router.push(routerAdvantageTaskInProgressPage);
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

  // =====================================================
  // MAIN DETAILS CARD
  // =====================================================
  Widget _detailsCard() {
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
            "7089 - Autopro",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          /// SUB TASKS
          const Text(
            "Category : Example 1",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Sub Service : Example 2",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          // /// LOCATION
          // Row(
          //   children: const [
          //     Icon(
          //       Icons.location_on_outlined,
          //       size: 16,
          //       color: Colors.black54,
          //     ),
          //     SizedBox(width: 6),
          //     Text(
          //       "MG Dubai Showroom (SZR)",
          //       style: TextStyle(
          //         fontSize: 13,
          //         color: Colors.black87,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 16),

          /// REMARKS
          const Text(
            "Job Description",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              "This is an example for a description of the work. During the live application, Job description will be available here.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// VEHICLE INFO LABEL
          Text(
            "VEHICLE INFORMATION",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.6,
            ),
          ),

          const SizedBox(height: 12),

          /// CHASSIS
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                TextSpan(
                  text: "Chassis Number : ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: "MA1XA3BC4JH567890",
                  style: TextStyle(
                    fontWeight: FontWeight.w700, // ✅ correct
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          /// MODEL
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                TextSpan(
                  text: "Vehicle Model : ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: "ZX-2450",
                  style: TextStyle(
                    fontWeight: FontWeight.w700, // ✅ correct
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // /// INVOICE / PR
          // const Text(
          //   "Invoice / Purchase Request PR",
          //   style: TextStyle(
          //     fontSize: 13,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.black87,
          //   ),
          // ),
          //
          // const SizedBox(height: 8),
          //
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.grey.shade300),
          //   ),
          //   child: Row(
          //     children: const [
          //       Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 28),
          //       SizedBox(width: 10),
          //       Expanded(
          //         child: Text(
          //           "File_456786.pdf",
          //           style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
