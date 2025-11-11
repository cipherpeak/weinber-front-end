import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class VisaAndDocument extends StatefulWidget {
  const VisaAndDocument({super.key});

  @override
  State<VisaAndDocument> createState() => _VisaAndDocumentState();
}

class _VisaAndDocumentState extends State<VisaAndDocument> {



  final List<Map<String, String>> documents = [
    {
      "title": "Visa Photo Copy",
      "file": "VisaDocument (1). pdf",
      "date": "08/11/2022",
    },
    {
      "title": "Labor Card",
      "file": "Labor Card - E5342 (1). pdf",
      "date": "08/11/2022",
    },
  ];


  final List<String> pendingUploads = [
    "Passport Photo Copy",
    "Emirates ID Photo Copy",
    "Work Permit",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Visa & Document Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Text(
              "VISA DETAILS",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 15),

            // ============================
            // ✅ VISA DETAILS FIELDS
            // ============================
            _buildField(Icons.calendar_today_outlined,
                "Visa Expiry Date", "24 December 2025"),

            _buildField(Icons.badge_outlined, "Emirates ID", "XXXXX XXX56"),

            _buildField(Icons.calendar_today_outlined, "Emirates ID Expiry",
                "23 December 2025"),

            _buildField(Icons.wallet_travel_outlined, "Passport Number",
                "AIB2C3D4EF"),

            _buildField(
              Icons.calendar_today_outlined,
              "Passport Expiry Date",
              "15 August 2024",
              valueColor: Colors.red,
            ),

            const SizedBox(height: 25),


            Text(
              "DOCUMENTS",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 15),

            ...documents.map((doc) => _buildDocumentCard(doc)).toList(),

            const SizedBox(height: 25),


            Text(
              "PENDING DOCUMENT UPLOADS",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),

            ...pendingUploads.map((item) => _buildPendingUpload(item)).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _buildField(IconData icon, String label, String value,
      {Color valueColor = Colors.black87}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: valueColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Text(
                "Non editable",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDocumentCard(Map<String, String> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc['title']!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              // PDF icon
              const Icon(Icons.picture_as_pdf,
                  size: 32, color: Colors.redAccent),
              const SizedBox(width: 12),

              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc['file']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc['date']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              // View File Button
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  "View File",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A6CF7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildPendingUpload(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title ',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                children: const [
                  TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),

          // Add button
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: const [
                Text(
                  "Add",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.add, size: 16, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
