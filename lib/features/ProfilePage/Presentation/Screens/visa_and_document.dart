import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../Model/visa_document_response_model.dart';

class VisaAndDocument extends StatefulWidget {
  const VisaAndDocument({super.key});

  @override
  State<VisaAndDocument> createState() => _VisaAndDocumentState();
}

class _VisaAndDocumentState extends State<VisaAndDocument> {

  late final VisaDocumentResponse visaData;

  @override
  void initState() {
    super.initState();

    // 🔹 Hardcoded Visa & Document Data
    visaData = VisaDocumentResponse(
      visaNumber: "VISA-987654321",
      visaExpiryDate: "30 December 2025",
      passportNumber: "P12345678",
      passportExpiryDate: "15 June 2028",
      emiratesIdExpiry: "10 March 2026",
      documents: [
        DocumentItem(
          type: "passport",
          name: "Passport Copy",
          file: "https://example.com/docs/passport.pdf",
          uploadedAt: "2024-06-15T10:30:00",
        ),
        DocumentItem(
          type: "visa",
          name: "Visa Copy",
          file: "https://example.com/docs/visa.pdf",
          uploadedAt: "2024-06-16T11:45:00",
        ),
        DocumentItem(
          type: "emirates_id",
          name: "Emirates ID",
          file: "https://example.com/docs/emirates_id.pdf",
          uploadedAt: "2024-06-18T09:15:00",
        ),
      ],
      pendingDocuments: [
        "Labour Card",
        "Insurance Document",
      ],
    );
  }

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
          "Visa & Document Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: buildVisaUI(),
    );
  }

  Widget buildVisaUI() {
    final data = visaData;

    return SingleChildScrollView(
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

          _buildField(Icons.badge_outlined, "Visa Number", data.visaNumber),
          _buildField(
            Icons.calendar_month,
            "Visa Expiry Date",
            data.visaExpiryDate,
            valueColor: Colors.red,
          ),

          _buildField(
            Icons.wallet_travel_outlined,
            "Passport Number",
            data.passportNumber,
          ),

          _buildField(
            Icons.calendar_today_outlined,
            "Passport Expiry Date",
            data.passportExpiryDate,
            valueColor: Colors.red,
          ),

          _buildField(
            Icons.credit_card_outlined,
            "Emirates ID Expiry",
            data.emiratesIdExpiry,
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

          ...data.documents.map((doc) => _buildDocumentCard(doc)).toList(),

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

          ...data.pendingDocuments
              .map((item) => _buildPendingUpload(item))
              .toList(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildField(
      IconData icon,
      String label,
      String value, {
        Color valueColor = Colors.black87,
      }) {
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
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildDocumentCard(DocumentItem doc) {
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
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 32,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.file.split('/').last,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doc.uploadedAt.split("T").first,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
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
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(text: title),
                  const TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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


