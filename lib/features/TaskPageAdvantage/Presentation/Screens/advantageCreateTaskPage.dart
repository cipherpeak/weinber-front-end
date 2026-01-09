import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';

class AdvantageCreateTaskScreen extends StatefulWidget {
  const AdvantageCreateTaskScreen({super.key});

  @override
  State<AdvantageCreateTaskScreen> createState() => _AdvantageCreateTaskScreenState();
}

class _AdvantageCreateTaskScreenState extends State<AdvantageCreateTaskScreen> {
  String? detailingSite;
  String? plu;
  String? category;
  String? subService;

  // ---------------- DUMMY DATA ----------------
  final detailingSites = [
    "7086 – Autopro",
    "7090 – Mobile Wash SZR",
    "7102 – Dubai Marina",
  ];

  final pluList = [
    "Number 1 (PLU eg.)",
    "Number 2 (PLU eg.)",
    "Number 3 (PLU eg.)",
  ];

  final categoryList = [
    "Category 1 eg.",
    "Category 2 eg.",
    "Category 3 eg.",
  ];

  final subServiceList = [
    "Sub Service 1 eg.",
    "Sub Service 2 eg.",
    "Sub Service 3 eg.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
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

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Detailing Site & Mobile Wash Sites", required: true),
            _dropdown(
              "Select or enter the site you’re working",
              items: detailingSites,
              value: detailingSite,
              onChanged: (val) => setState(() => detailingSite = val),
            ),

            _label("Select PLU", required: true),
            _dropdown(
              "Number 2 (PLU eg.)",
              items: pluList,
              value: plu,
              onChanged: (val) => setState(() => plu = val),
            ),

            _label("Category", required: true),
            _dropdown(
              "Category 2 eg.",
              items: categoryList,
              value: category,
              onChanged: (val) => setState(() => category = val),
            ),

            _label("Sub Service"),
            _dropdown(
              "Sub Service 1 eg.",
              items: subServiceList,
              value: subService,
              onChanged: (val) => setState(() => subService = val),
            ),

            const SizedBox(height: 20),

            // ================= VEHICLE INFO =================
            Text(
              "VEHICLE INFORMATION",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 12),

            _label("Chassis Number", required: true),
            _textField("Enter your vehicle chassis number"),

            _label("Vehicle Model / Type", required: true),
            _textField("Enter your vehicle model or type"),

            _label("Vehicle Image", required: true),
            _vehicleImageField(),

            const SizedBox(height: 20),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  router.go(routerAdvantageTaskPage);
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _label(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 10),
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

  Widget _textField(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
      String hint, {
        required List<String> items,
        String? value,
        ValueChanged<String?>? onChanged,
      }) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(
            hint,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _vehicleImageField() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: const [
          Icon(Icons.cloud_upload_outlined, size: 36, color: Colors.grey),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Select a file",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: " and drop here",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            style: TextStyle(fontSize: 12),
          ),
          SizedBox(height: 6),
          Text(
            "Supports PNG, JPEG formats. Max file size 4MB.",
            style: TextStyle(fontSize: 10, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
