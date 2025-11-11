import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
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
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Center(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage:
                    AssetImage('assets/images/profile.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),


            _buildLabel(Icons.phone_outlined, "Mobile Number"),
            _editableField("+1 123 456 7890"),


            _buildLabel(Icons.email_outlined, "Email"),
            _editableField("john.doe@example.com"),


            _buildLabel(Icons.location_on_outlined, "Address"),
            _editableField("123 Main Road, Anytown, Dubai -12345"),


            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(Icons.calendar_today_outlined, "Date of Birth"),
                      _editableField("06 October 1867"),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(Icons.flag_outlined, "Nationality"),
                      _editableField("+1 123 456 7890"),
                    ],
                  ),
                ),
              ],
            ),

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

            // Full Name
            _buildLabel(Icons.person_outline, "Full Name"),
            _nonEditableField("Robert Doe"),

            // Phone
            _buildLabel(Icons.phone_outlined, "Mobile Number"),
            _nonEditableField("+1 123 456 7890"),

            // Relation
            _buildLabel(Icons.people_outline, "Relation with Employee"),
            _nonEditableField("Brother"),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }


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
