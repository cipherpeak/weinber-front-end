import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/utils/Common%20Functions/compressImage.dart';
import '../../../../core/constants/page_routes.dart';
import '../../Api/advantage_task_repo.dart';

class AdvantageCreateTaskScreen extends StatefulWidget {
  const AdvantageCreateTaskScreen({super.key});

  @override
  State<AdvantageCreateTaskScreen> createState() =>
      _AdvantageCreateTaskScreenState();
}

class _AdvantageCreateTaskScreenState
    extends State<AdvantageCreateTaskScreen> {
  final repo = AdvantageTaskRepository();
  final picker = ImagePicker();

  String? detailingSite;
  String? plu;
  String? category;
  String? subService;
  final chassisController = TextEditingController();

  File? selectedImage;
  bool loading = false;

  // ---------------- DUMMY DATA ----------------
  final detailingSites = [
    "7086_autopro",
    "7090_mobile_wash_szr",
    "7102_dubai_marina",
  ];

  final pluList = ["1", "2", "3"];
  final categoryList = ["Category 1 eg.", "Category 2 eg.", "Category 3 eg."];
  final subServiceList = ["Sub Service 1 eg.", "Sub Service 2 eg."];

  // ================= IMAGE PICK =================
  Future<void> _pickImage() async {
    final picked =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // ================= CREATE TASK =================
  Future<void> _createTask() async {
    var compressedImage;

    if(selectedImage!=null){
      compressedImage = await compressImage(selectedImage!);
    }
    if (detailingSite == null ||
        plu == null ||
        category == null ||
        chassisController.text.isEmpty ||
        compressedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await repo.createAdvantageTask(
        detailingSite: detailingSite!,
        plu: plu!,
        category: category!,
        subService: subService ?? "",
        chassisNumber: chassisController.text,
        image: compressedImage!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Advantage task created successfully"),
        ),
      );

      router.go(routerAdvantageTaskPage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create Task",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dropdown("Detailing Site *", detailingSites,
                value: detailingSite,
                onChanged: (v) => setState(() => detailingSite = v)),

            _dropdown("PLU *", pluList,
                value: plu, onChanged: (v) => setState(() => plu = v)),

            _dropdown("Category *", categoryList,
                value: category,
                onChanged: (v) => setState(() => category = v)),

            _dropdown("Sub Service", subServiceList,
                value: subService,
                onChanged: (v) => setState(() => subService = v)),

            _textField("Chassis Number *", chassisController),

            const SizedBox(height: 10),
            _imagePicker(),

            const SizedBox(height: 20),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _createTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: loading
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
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _dropdown(String label, List<String> items,
      {String? value, ValueChanged<String?>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: const Text("Select"),
              items: items
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _textField(String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(hint,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _imagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: selectedImage == null
            ? const Center(
          child: Text("Tap to upload vehicle image",
              style: TextStyle(color: Colors.black54)),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(selectedImage!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
