import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  final PersonalInformationRepository _repo = PersonalInformationRepository();

  PersonalInfoResponse? personalInfo;
  bool isLoading = true;
  bool isSaving = false;
  String? error;

  final mobController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    _loadPersonalInfo();
  }

  Future<void> _loadPersonalInfo() async {
    try {
      final res = await _repo.fetchPersonalInfo();

      mobController.text = res.mobNumber;
      emailController.text = res.email;
      addressController.text = res.address;

      setState(() {
        personalInfo = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load personal information";
        isLoading = false;
      });
    }
  }

  // ================= ACTIONS =================

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => pickedImage = File(picked.path));
    }
  }

  Future<void> _updateProfile() async {
    setState(() => isSaving = true);

    try {
      await _repo.updatePersonalInfo(
        profilePic: pickedImage,
        mobNumber: mobController.text.trim(),
        email: emailController.text.trim(),
        address: addressController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile updated")));

      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isSaving = false);
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
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: isSaving ? null : _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: isSaving
                  ? const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text("Save"),
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text(error!));

    final info = personalInfo!;
    final emergency =
    info.emergencyContacts.isNotEmpty ? info.emergencyContacts.first : null;

    return _buildPersonalInfoUI(info, emergency);
  }

  // ================= UI (UNCHANGED STYLE) =================

  Widget _buildPersonalInfoUI(
      PersonalInfoResponse info,
      EmergencyContact? emergency,
      ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// PROFILE IMAGE
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 55,
                    foregroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : info.proPic.isNotEmpty
                        ? NetworkImage("https://www.cipher-peak.com${info.proPic}")
                        : null,
                    child: (info.proPic.isEmpty && pickedImage == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          _buildLabel(Icons.phone_outlined, "Mobile Number"),
          _editableField(controller: mobController),

          _buildLabel(Icons.email_outlined, "Email"),
          _editableField(controller: emailController),

          _buildLabel(Icons.location_on_outlined, "Address"),
          _editableField(controller: addressController, maxLines: 2),

          const SizedBox(height: 25),

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

  // ================= FIELDS =================

  Widget _buildLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _editableField({
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      height: 55,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 25, top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: _fieldDecoration(),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
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
      child: Text(value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
