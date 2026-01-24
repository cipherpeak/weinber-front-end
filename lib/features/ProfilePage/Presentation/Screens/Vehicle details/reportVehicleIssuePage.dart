import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/constants.dart';
import '../../../Api/vehicle_repository.dart';


class ReportVehicleIssuePage extends StatefulWidget {
  const ReportVehicleIssuePage({super.key});

  @override
  State<ReportVehicleIssuePage> createState() =>
      _ReportVehicleIssuePageState();
}

class _ReportVehicleIssuePageState extends State<ReportVehicleIssuePage> {

  final repo = VehicleRepository();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool submitting = false;
  File? pickedImage;

  String status = "open";

  // ---------------- IMAGE PICK ----------------

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        pickedImage = File(picked.path);
      });
    }
  }

  // ---------------- SUBMIT ----------------

  Future<void> _submitIssue() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => submitting = true);

    try {
      final today = DateTime.now();
      final date =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      await repo.reportVehicleIssue(
        title: titleController.text.trim(),
        reportedDate: date,
        status: status,
        description: descriptionController.text.trim(),
        image: pickedImage,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle issue reported successfully")),
      );

      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => submitting = false);
    }
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Report Vehicle Issue",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      bottomNavigationBar: _bottomButton(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _infoCard(),

            const SizedBox(height: 22),

            const SizedBox(height: 14),

            _label("Issue Title"),
            _textField(titleController, "Eg: Engine overheating"),

            const SizedBox(height: 18),

            _label("Status"),
            const SizedBox(height: 8),
            _statusSelector(),

            const SizedBox(height: 18),

            _label("Description"),
            _descriptionField(),

            const SizedBox(height: 22),

            _sectionTitle("Evidence (Optional)"),
            const SizedBox(height: 10),
            _imagePicker(),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE9EEFF), Color(0xFFF6F8FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(.15)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.car_repair, color: primaryColor),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Report any vehicle issue immediately so that maintenance can be arranged quickly.",
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _statusSelector() {
    return Row(
      children: [
        _statusChip(
          value: "open",
          label: "Open",
          icon: Icons.report_problem_outlined,
          activeColor: primaryColor,
        ),
        const SizedBox(width: 10),
        _statusChip(
          value: "resolved",
          label: "Resolved",
          icon: Icons.check_circle_outline,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget _statusChip({
    required String value,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final selected = status == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => status = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? activeColor : Colors.grey.shade300,
              width: 1.2,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: activeColor.withOpacity(.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Widget _statusChip(String value, String label, IconData icon) {
  //   final selected = status == value;
  //
  //   return Expanded(
  //     child: GestureDetector(
  //       onTap: () => setState(() => status = value),
  //       child: AnimatedContainer(
  //         duration: const Duration(milliseconds: 250),
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //         decoration: BoxDecoration(
  //           color: selected ? primaryColor : Colors.white,
  //           borderRadius: BorderRadius.circular(14),
  //           border: Border.all(
  //               color: selected ? primaryColor : Colors.grey.shade300),
  //           boxShadow: selected
  //               ? [
  //             BoxShadow(
  //               color: primaryColor.withOpacity(.3),
  //               blurRadius: 10,
  //               offset: const Offset(0, 5),
  //             )
  //           ]
  //               : [],
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(icon,
  //                 size: 18, color: selected ? Colors.white : Colors.black54),
  //             const SizedBox(width: 8),
  //             Text(
  //               label,
  //               style: TextStyle(
  //                 color: selected ? Colors.white : Colors.black87,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 170,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: primaryColor.withOpacity(.25),
            style: BorderStyle.solid,
            width: 1.4,
          ),
        ),
        child: pickedImage != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.file(
            pickedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined,
                size: 36, color: primaryColor),
            SizedBox(height: 8),
            Text(
              "Upload vehicle issue image",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Tap to choose from gallery",
              style: TextStyle(fontSize: 12, color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: submitting ? null : _submitIssue,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
          child: submitting
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            "Submit Vehicle Issue",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }






  // ---------------- WIDGETS ----------------

  Widget _label(String text, {bool required = true}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        children: [
          if (required)
            const TextSpan(
              text: " *",
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _boxDecoration(),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,


          hintStyle: const TextStyle(color: Color(0xFFB0B5C0), fontSize: 13),
        ),
      ),
    );
  }

  Widget _descriptionField() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: _boxDecoration(),
      child: TextField(
        controller: descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Describe the issue clearly",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: TextStyle(color: Color(0xFFB0B5C0), fontSize: 13),
        ),
      ),
    );
  }


  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
