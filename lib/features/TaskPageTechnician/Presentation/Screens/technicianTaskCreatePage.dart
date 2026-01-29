import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/constants.dart' as AppColor;
import '../../../../core/constants/page_routes.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../../Api/technician_task_repo.dart';

class TechnicianCreateTaskScreen extends ConsumerStatefulWidget {
  const TechnicianCreateTaskScreen({super.key});

  @override
  ConsumerState<TechnicianCreateTaskScreen> createState() =>
      _TechnicianCreateTaskScreenState();
}

class _TechnicianCreateTaskScreenState
    extends ConsumerState<TechnicianCreateTaskScreen> {

  final _formKey = GlobalKey<FormState>();
  final repo = TechnicianTaskRepository();

  bool creating = false;

  // ================= CONTROLLERS =================

  final siteController = TextEditingController();
  final jobDescController = TextEditingController();
  final spareController = TextEditingController();
  final partNumberController = TextEditingController();
  final itemController = TextEditingController();
  final quantityController = TextEditingController();

  String? selectedBay;
  String? selectedMachineType;
  String? selectedSerial;

  final List<String> bayNumbers = ["bay_1", "bay_2", "bay_3", "bay_4"];

  final List<String> machineTypes = [
    "hp_machine",
    "lp_machine",
    "hydraulic_press",
  ];

  final List<String> machineSerialNumbers = [
    "SN001",
    "SN002",
    "SN003",
  ];

  // ================= SUBMIT =================

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedBay == null ||
        selectedMachineType == null ||
        selectedSerial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill all dropdown fields"),
        ),
      );
      return;
    }

    setState(() => creating = true);

    try {
      await repo.createTechnicianTask(
        siteNumber: siteController.text.trim(),
        bayNumber: selectedBay!,
        machineType: selectedMachineType!,
        machineSerialNumber: selectedSerial!,
        jobDescription: jobDescController.text.trim(),
        sparePartDetails: spareController.text.trim(),
        partNumber: partNumberController.text.trim() == ""
            ? 0
            : int.parse(partNumberController.text.trim()),
        item: itemController.text.trim(),
        quantity: int.parse(quantityController.text.trim()),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Task created successfully"),
        ),
      );

      ref.read(bottomNavProvider.notifier).changeIndex(0);
      router.go(routerTechnicianTaskPage);


      // go back to list

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) setState(() => creating = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Task",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _label("Site Number", required: true),
              _textField(controller: siteController, hint: "Enter site number"),

              _label("Bay Number", required: true),
              _dropdownField(
                "Select bay number",
                value: selectedBay,
                items: bayNumbers,
                onChanged: (v) => setState(() => selectedBay = v),
              ),

              _label("Machine Type", required: true),
              _dropdownField(
                "Select machine type",
                value: selectedMachineType,
                items: machineTypes,
                onChanged: (v) => setState(() => selectedMachineType = v),
              ),

              _label("Machine Serial Number", required: true),
              _dropdownField(
                "Select serial number",
                value: selectedSerial,
                items: machineSerialNumbers,
                onChanged: (v) => setState(() => selectedSerial = v),
              ),

              _label("Job Description", required: true),
              _textField(
                controller: jobDescController,
                hint: "Briefly describe job",
                maxLines: 3,
              ),

              _label("Spare Parts Details", required: true),
              _textField(
                controller: spareController,
                hint: "Add spare parts details",
                maxLines: 2,
              ),

              _label("Part Number", required: true),
              _textField(controller: partNumberController, hint: "Enter part number"),

              _label("Item", required: true),
              _textField(controller: itemController, hint: "Enter item name"),

              _label("Quantity", required: true),
              _textField(
                controller: quantityController,
                hint: "Enter quantity",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: creating ? null : _createTask,
                  child: creating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Create Task",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

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
              const TextSpan(text: " *", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: _fieldDecoration(),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (v) =>
        (v == null || v.isEmpty) ? "This field is required" : null,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _dropdownField(
      String hint, {
        required List<String> items,
        required String? value,
        required ValueChanged<String?> onChanged,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: _fieldDecoration(),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(e.replaceAll('_', ' ').toUpperCase()),
          ),
        )
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
