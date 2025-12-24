import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/constants.dart' as AppColor;
import '../../../../core/constants/page_routes.dart';

class TechnicianCreateTaskScreen extends StatefulWidget {
  const TechnicianCreateTaskScreen({super.key});

  @override
  State<TechnicianCreateTaskScreen> createState() =>
      _TechnicianCreateTaskScreenState();
}

class _TechnicianCreateTaskScreenState
    extends State<TechnicianCreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> bayNumbers = ["Bay 01", "Bay 02", "Bay 03", "Bay 04"];

  final List<String> machineTypes = [
    "High Pressure Machine",
    "Low Pressure Machine",
    "Hydraulic Press",
  ];

  final List<String> machineSerialNumbers = [
    "HP-2023-001",
    "HP-2023-002",
    "LP-2022-015",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Task",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Site Number"),
              _textField(
                initialValue: "",
                hint: 'Enter site number',
                // enabled: false,
              ),

              _label("Bay Number", required: true),
              _dropdownField(
                "Select or enter your bay number",
                items: bayNumbers,
              ),

              _label("Machine Type", required: true),
              _dropdownField("Select machine type", items: machineTypes),

              _label("Machine Serial Number", required: true),
              _dropdownField(
                "Select or enter machine serial number",
                items: machineSerialNumbers,
              ),

              _label("Job Description", required: true),
              _textField(hint: "Briefly describe your job here", maxLines: 3),

              _label("Spare Parts Details", required: true),
              _textField(hint: "Add here", maxLines: 3),

              _label("Part Number", required: true),
              _textField(hint: "Enter part number"),

              _label("Item", required: true),
              _textField(hint: "Enter item name"),

              _label("Quantity", required: true),
              _textField(
                hint: "Enter quantity",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              /// ================= CREATE BUTTON =================
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Create Task",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // HELPERS
  // =====================================================

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          children: [
            TextSpan(text: text),
            if (required)
              const TextSpan(
                text: " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    String? hint,
    String? initialValue,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: _fieldDecoration(), // outer rectangle only
      child: TextFormField(
        initialValue: initialValue,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _dropdownField(String hint, {required List<String> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: false,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black54,
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14, //  normal size for selected values
                    color: Colors.black87,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 12, //  smaller hint text
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(14),
        style: const TextStyle(
          fontSize: 14, //  selected value text size
          color: Colors.black87,
        ),
      ),
    );
  }

  BoxDecoration _fieldDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
