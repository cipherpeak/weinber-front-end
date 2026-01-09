

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../Api/visa_document_repository.dart';
import '../../Model/visa_document_response_model.dart';

class VisaAndDocument extends StatefulWidget {
  const VisaAndDocument({super.key});

  @override
  State<VisaAndDocument> createState() => _VisaAndDocumentState();
}

class _VisaAndDocumentState extends State<VisaAndDocument> {

  VisaDocumentResponse? visaData;
  bool isLoading = true;
  String? error;
  bool isUploading = false;

  final VisaDocumentRepository _repo = VisaDocumentRepository();

  @override
  void initState() {
    super.initState();
    _loadVisaData();
  }

  Future<void> _loadVisaData() async {
    try {
      final res = await _repo.fetchVisaData();
      setState(() {
        visaData = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load visa & document details";
        isLoading = false;
      });
    }
  }

  Future<void> _uploadPendingDocument(String documentType) async {
    try {
      debugPrint("📂 Opening file picker...");

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: false,
      );

      if (result == null ||
          result.files.isEmpty ||
          result.files.single.path == null) {
        debugPrint("⚠️ File picking cancelled or no file selected");
        return;
      }

      final file = File(result.files.single.path!);
      debugPrint("✅ File selected: ${file.path}");

      setState(() => isUploading = true);

      final docType = documentType.toLowerCase().replaceAll(" ", "_");
      debugPrint("📤 Uploading as type: $docType");

      await _repo.uploadDocument(
        documentType: docType,
        file: file,
      );

      await _loadVisaData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document uploaded successfully")),
        );
      }
    } catch (e, st) {
      debugPrint("❌ FILE PICK / UPLOAD ERROR => $e");
      debugPrint("🧵 STACK TRACE ↓↓↓");
      debugPrintStack(stackTrace: st);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File picker or upload failed. Check logs."),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Visa & Document Details",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    return buildVisaUI(visaData!);
  }


  Widget buildVisaUI(VisaDocumentResponse data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildField(Icons.calendar_month, "Visa Expiry Date",
              _val(data.visaExpiryDate), valueColor: Colors.red),

          _buildField(Icons.wallet_travel_outlined, "Passport Number",
              _val(data.passportNumber)),

          _buildField(Icons.calendar_today_outlined, "Passport Expiry Date",
              _val(data.passportExpiryDate), valueColor: Colors.red),

          _buildField(Icons.credit_card_outlined, "Emirates ID Number",
              _val(data.emiratesIdNumber)),

          _buildField(Icons.credit_card_outlined, "Emirates ID Expiry",
              _val(data.emiratesIdExpiry)),

          const SizedBox(height: 25),

          _sectionTitle("DOCUMENTS"),
          const SizedBox(height: 15),

          if (data.documents.isEmpty)
            _emptyText("No documents uploaded")
          else
            ...data.documents.map((doc) => _buildDocumentCard(doc)).toList(),

          const SizedBox(height: 25),

          _sectionTitle("PENDING DOCUMENT UPLOADS", color: Colors.red),
          const SizedBox(height: 15),

          if (data.pendingDocuments.isEmpty)
            _emptyText("No pending documents 🎉")
          else
            ...data.pendingDocuments
                .map((item) => _buildPendingUpload(item))
                .toList(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _val(String? v) => (v == null || v.isEmpty) ? "Not provided" : v;

  Widget _sectionTitle(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.grey.shade600,
      ),
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text, style: const TextStyle(color: Colors.black45)),
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
          GestureDetector(
            onTap: isUploading ? null : () => _uploadPendingDocument(title),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUploading ? Colors.grey : primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  isUploading
                      ? const SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.add, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  const Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


