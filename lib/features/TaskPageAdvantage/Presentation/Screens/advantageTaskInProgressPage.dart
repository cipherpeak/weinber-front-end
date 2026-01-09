import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../../../utils/Common Widgets/percentageBar.dart';
import '../../../TaskPageDax/Presentation/Provider/daxPercentageProviderInProgressPage.dart';

class AdvantageTaskInProgressScreen extends ConsumerWidget {
  const AdvantageTaskInProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklist = ref.watch(taskChecklistProvider);
    final progress = ref.watch(percentageProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskInfoCard(),

            const SizedBox(height: 20),





            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "${(progress * 100).toInt()}% Completed",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 20),
            /// ================= PROGRESS BAR =================
            PercentageBar(percentageProgressProvider),
            const SizedBox(height: 20),
            /// ================= CHECKLIST =================
            _checkItem(
              ref,
              index: 0,
              title: "Service 1",
              isRequired: false,
            ),
            _checkItem(
              ref,
              index: 1,
              title: "Service 2",
              isRequired: true,
            ),
            _checkItem(
              ref,
              index: 2,
              title: "Service 3",
              isRequired: true,
            ),
            _checkItem(
              ref,
              index: 3,
              title: "Service 4",
              isRequired: true,
            ),

            const SizedBox(height: 24),

            /// ================= PROGRESS UPDATE =================
            Text(
              "PROGRESS UPDATE",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 10),

            _progressInput(),
          ],
        ),
      ),

      /// ================= BOTTOM CTA =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              _showCompleteTaskDialog(context);
            },

            child: const Text(
              "End Task",
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
  // TASK INFO CARD
  // =====================================================
  Widget _taskInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE + ADD PROGRESS
          Row(
            children: [
              const Expanded(
                child: Text(
                  "7089 - Autopro",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              /// ADD PROGRESS CHIP
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(245, 234, 203, 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  Text(
                  "In Progress",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBFA152),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text("Category:  Example 1", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          const Text("Sub Service:  Example 2", style: TextStyle(fontSize: 12)),

          // const SizedBox(height: 6),
          // Row(
          //   children: const [
          //     Icon(Icons.location_on_outlined, size: 16),
          //     SizedBox(width: 6),
          //     Text("MG Dubai Showroom (SZR)"),
          //   ],
          // ),

          const SizedBox(height: 8),
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
  // CHECKLIST ITEM
  // =====================================================
  Widget _checkItem(
      WidgetRef ref, {
        required int index,
        required String title,
        required bool isRequired,
      }) {
    final checklist = ref.watch(taskChecklistProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black),
                children: [
                  TextSpan(text: title),
                  if (isRequired)
                    const TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),

          /// ROUNDED CHECKBOX
          Checkbox(
            value: checklist[index],
            activeColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            onChanged: (val) {
              final updated = [...checklist];
              updated[index] = val ?? false;
              ref.read(taskChecklistProvider.notifier).state = updated;
            },
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
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add progress notes here",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
        ),
      ],
    );
  }

  void _showCompleteTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// DRAG INDICATOR
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 16),

                /// TITLE
                const Text(
                  "Complete Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                /// FINAL COMMENTS
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Final Comments (Optional)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                      "Add any final notes about the completed task",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// MARK COMPLETE BUTTON
                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white),
                    label: const Text(
                      "Mark Task as Completed",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      router.go(routerAdvantageTaskPage);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                /// CANCEL BUTTON
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
