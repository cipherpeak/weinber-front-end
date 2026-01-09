class VisaDocumentResponse {
  final String? visaExpiryDate;
  final String? passportNumber;
  final String? passportExpiryDate;
  final String? emiratesIdNumber;
  final String? emiratesIdExpiry;
  final List<DocumentItem> documents;
  final List<String> pendingDocuments;

  VisaDocumentResponse({
    required this.visaExpiryDate,
    required this.passportNumber,
    required this.passportExpiryDate,
    required this.emiratesIdNumber,
    required this.emiratesIdExpiry,
    required this.documents,
    required this.pendingDocuments,
  });

  factory VisaDocumentResponse.fromJson(Map<String, dynamic> json) {
    return VisaDocumentResponse(
      visaExpiryDate: json["visa_expiry_date"],
      passportNumber: json["passport_number"],
      passportExpiryDate: json["passport_expiry_date"],
      emiratesIdNumber: json["emirates_id_number"],
      emiratesIdExpiry: json["emirates_id_expiry"],
      documents: (json["documents"] as List? ?? [])
          .map((e) => DocumentItem.fromJson(e))
          .toList(),
      pendingDocuments:
      List<String>.from(json["pending_documents_list"] ?? []),
    );
  }
}

class DocumentItem {
  final String type;
  final String name;
  final String file;
  final String uploadedAt;

  DocumentItem({
    required this.type,
    required this.name,
    required this.file,
    required this.uploadedAt,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      type: json["document_type"] ?? "",
      name: json["document_name"] ?? "",
      file: json["document_file"] ?? "",
      uploadedAt: json["uploaded_at"] ?? "",
    );
  }
}
