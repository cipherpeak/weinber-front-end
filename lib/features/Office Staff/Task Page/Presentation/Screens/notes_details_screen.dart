import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';

class NoteDetailsScreen extends StatelessWidget {
  const NoteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NOTE TITLE
            const _FieldLabel(label: "Note Title"),
            const SizedBox(height: 6),
            _readOnlyBox(
              child: const Text(
                "Follow-Up with Vendor",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// NOTE BODY
            const _FieldLabel(label: "Note Body"),
            const SizedBox(height: 6),

            Expanded(
              child: _readOnlyBox(
                child: SingleChildScrollView(
                  child: const Text(
                    "• Please reach out to our equipment supplier regarding the delayed shipment for the high-pressure tools.\n\n"
                        "• They had initially committed to dispatching everything by the 12th, but we haven’t received any update after their last confirmation.\n\n"
                        "• Call them to get the revised delivery schedule, ask if any items are on backorder, and request written confirmation via email.\n\n"
                        "• Once you have the details, update the shared procurement sheet and notify the operations team so they can plan the workflow for next week without disruptions.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: mark note as done
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text(
                "Mark as Done",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- READ-ONLY BOX ----------------
  Widget _readOnlyBox({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// FIELD LABEL
class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }
}
