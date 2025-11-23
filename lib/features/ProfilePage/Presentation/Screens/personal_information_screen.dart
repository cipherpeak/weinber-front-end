import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../Api/personal_information_repository.dart';
import '../../Model/personal_information_response.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  PersonalInfoResponse? personalInfo;
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPersonalInfo();
  }

  Future<void> loadPersonalInfo() async {
    try {
      final repo = PersonalInformationRepository();
      final data = await repo.fetchPersonalInfo();

      setState(() {
        personalInfo = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Personal Information",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 15),
              ),
            )
          : buildPersonalInfoUI(),
    );
  }

  Widget buildPersonalInfoUI() {
    final info = personalInfo!;
    final emergency = info.emergencyContacts.isNotEmpty
        ? info.emergencyContacts.first
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 55,
                  foregroundImage: NetworkImage(
                    "https://www.cipher-peak.com${info.proPic}",
                  ),
                  onForegroundImageError: (exception, stackTrace) {},
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ============================
          // MOBILE
          // ============================
          _buildLabel(Icons.phone_outlined, "Mobile Number"),
          _editableField(info.mobNumber),

          // ============================
          // EMAIL
          // ============================
          _buildLabel(Icons.email_outlined, "Email"),
          _editableField(info.email),

          // ============================
          // ADDRESS
          // ============================
          _buildLabel(Icons.location_on_outlined, "Address"),
          _editableField(info.address),

          // ============================
          // DOB + Nationality
          // ============================
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(Icons.calendar_today_outlined, "Date of Birth"),
                    _editableField(info.dob),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(Icons.flag_outlined, "Nationality"),
                    _editableField(info.nationality),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // ============================
          // EMERGENCY CONTACT SECTION
          // ============================
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "EMERGENCY CONTACT INFO",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 15),

          if (emergency != null) ...[
            _buildLabel(Icons.person_outline, "Full Name"),
            _nonEditableField(emergency.name),

            _buildLabel(Icons.phone_outlined, "Mobile Number"),
            _nonEditableField(emergency.phone),

            _buildLabel(Icons.people_outline, "Relation with Employee"),
            _nonEditableField(emergency.relation),
          ],

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------

  Widget _buildLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _editableField(String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: _fieldDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.edit, size: 18, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _nonEditableField(String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: _fieldDecoration(),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
