import 'package:flutter/material.dart';

import '../../../../../core/constants/page_routes.dart';


class FinesAndPenaltiesScreen extends StatelessWidget {
  const FinesAndPenaltiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fines & Penalties",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// OUTSTANDING FINES
            _sectionTitle("OUTSTANDING FINES"),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: (){
                router.push(routerFinesAndPenaltiesDetailsPage);
              },
              child: _FineCard(
                title: "Speeding Violation",
                amount: "AED 45",
                issuedDate: "15 August 2025",
                status: FineStatus.unpaid,
              ),
            ),

            const SizedBox(height: 25),

            /// PAID FINES HISTORY
            _sectionTitle("PAID FINES HISTORY"),
            const SizedBox(height: 12),

            _FineCard(
              title: "Illegal Parking",
              amount: "AED 45",
              issuedDate: "15 August 2025",
              paidDate: "10 July 2025",
              status: FineStatus.paid,
            ),

            const SizedBox(height: 12),

            _FineCard(
              title: "Expired Vehicle Registration",
              amount: "AED 85",
              issuedDate: "15 August 2025",
              paidDate: "10 July 2025",
              status: FineStatus.paid,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
      ),
    );
  }
}

/// ENUM FOR STATUS
enum FineStatus { paid, unpaid }

/// FINE CARD WIDGET
class _FineCard extends StatelessWidget {
  final String title;
  final String amount;
  final String issuedDate;
  final String? paidDate;
  final FineStatus status;

  const _FineCard({
    required this.title,
    required this.amount,
    required this.issuedDate,
    required this.status,
    this.paidDate,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status == FineStatus.paid;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// STATUS ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isPaid
                  ? const Color(0xFFE6F7EC)
                  : const Color(0xFFFFF2E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPaid ? Icons.check : Icons.warning_amber_rounded,
              color: isPaid ? const Color(0xFF5ED18F) : const Color(0xFFFFB74D),
            ),
          ),

          const SizedBox(width: 12),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPaid
                      ? "Issued On: $issuedDate\nPaid On: $paidDate"
                      : "Issued On: $issuedDate",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          /// AMOUNT + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xFFE6F7EC)
                      : const Color(0xFFFFF2E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaid ? "Paid" : "Unpaid",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPaid
                        ? const Color(0xFF5ED18F)
                        : const Color(0xFFFF9800),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.black45,
          ),
        ],
      ),
    );
  }
}
