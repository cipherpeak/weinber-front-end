import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import '../../../../../core/constants/constants.dart';

import '../../../Api/leave_appy_repo.dart';


class LeaveApplyPage extends StatefulWidget {
  const LeaveApplyPage({super.key});

  @override
  State<LeaveApplyPage> createState() => _LeaveApplyPageState();
}

class _LeaveApplyPageState extends State<LeaveApplyPage> {
  final LeaveApplyRepository _repo = LeaveApplyRepository();

  final TextEditingController totalDaysCtrl = TextEditingController();
  final TextEditingController reasonCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  String? category;
  DateTime? startDate;
  DateTime? endDate;

  DateTime? passportFromDate;
  DateTime? passportToDate;


  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  File? signatureFile;
  File? attachment;
  File? signature;

  bool isSubmitting = false;

  Future<void> _pickPassportDate(bool isFrom) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        if (isFrom) {
          passportFromDate = d;
        } else {
          passportToDate = d;
        }
      });
    }
  }


  String _apiDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, "0")}-${d.day.toString().padLeft(2, "0")}";

  Future<void> _pickFile(bool isSignature) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isSignature) {
          signature = File(result.files.single.path!);
        } else {
          attachment = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        if (isStart) {
          startDate = d;
        } else {
          endDate = d;
        }
      });
    }
  }

  Future<void> _submit() async {

    final signFile = await _exportSignature();

    if (signFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide your signature")),
      );
      return;
    }

    if (category == null ||
        startDate == null ||
        endDate == null ||
        totalDaysCtrl.text.isEmpty ||
        reasonCtrl.text.isEmpty ||
        passportFromDate == null||
        passportToDate == null ||
        addressCtrl.text.isEmpty
        ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    try {
      setState(() => isSubmitting = true);

      await _repo.applyLeave(
        category: category!,
        startDate: _apiDate(startDate!),
        endDate: _apiDate(endDate!),
        totalDays: totalDaysCtrl.text.trim(),
        reason: reasonCtrl.text.trim(),
        passportFrom: _apiDate(passportFromDate!),
        passportTo: _apiDate(passportToDate!),
        address: addressCtrl.text.trim(),
        attachment: attachment,
        signature: signFile,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Leave applied successfully")));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to apply leave")));
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  Widget _signatureBox() {
    return Container(
      decoration: _box(),
      height: 140,
      child: Column(
        children: [
          Expanded(
            child: Signature(
              controller: _signatureController,
              backgroundColor: Colors.transparent,
            ),
          ),
          Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _signatureController.clear(),
                child: const Text("Clear"),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<File?> _exportSignature() async {
    if (_signatureController.isEmpty) return null;

    final data = await _signatureController.toPngBytes();
    if (data == null) return null;

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/signature.png");
    await file.writeAsBytes(data);

    return file;
  }


  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("LEAVE FORM",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Category of Leave"),
            _dropdown(),
            _gap(),

            Row(
              children: [
                Expanded(child: _dateBox("From", startDate, () => _pickDate(true))),
                const SizedBox(width: 12),
                Expanded(child: _dateBox("To", endDate, () => _pickDate(false))),
              ],
            ),

            _gap(),
            _label("Total Number of Leave Days"),
            _input(totalDaysCtrl, "Enter number of days"),

            _gap(),
            _label("Reason for the Leave"),
            _input(reasonCtrl, "Briefly describe", max: 3),

            _gap(),
            Row(
              children: [
                Expanded(
                  child: _dateBox(
                    "Passport Required From",
                    passportFromDate,
                        () => _pickPassportDate(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _dateBox(
                    "Passport Required To",
                    passportToDate,
                        () => _pickPassportDate(false),
                  ),
                ),
              ],
            ),


            _gap(),
            _label("Address During the Leave"),
            _input(addressCtrl, "Enter your address"),

            _gap(),
            _label("Attach Media"),
            _fileBox(attachment, () => _pickFile(false)),

            _gap(),
            _label("Signature"),
            _signatureBox(),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : const Text("Submit Leave Form",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
      const Text(" *", style: TextStyle(color: Colors.red))
    ]),
  );

  Widget _input(TextEditingController c, String hint, {int max = 1}) {
    return Container(
      decoration: _box(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: c,
        maxLines: max,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }


  Widget _dropdown() {
    return Container(
      decoration: _box(),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: category,
          hint: const Text(
            "Select the type of leave you're taking",
            style: TextStyle(color: Colors.black38, fontSize: 13),
          ),
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: "annual", child: Text("Annual")),
            DropdownMenuItem(value: "casual", child: Text("Casual")),
            DropdownMenuItem(value: "sick", child: Text("Sick")),
          ],
          onChanged: (v) => setState(() => category = v),
        ),
      ),
    );
  }


  Widget _dateBox(String label, DateTime? d, VoidCallback onTap) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _label(label),
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: _box(),
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(d == null ? "Select date" : _apiDate(d),
                  style: TextStyle(color: d == null ? Colors.black38 : Colors.black)),
              const Icon(Icons.calendar_month_outlined, size: 18),
            ],
          ),
        ),
      )
    ]);
  }

  Widget _fileBox(File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _box(dashed: true),
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.cloud_upload_outlined, color: primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                file == null ? "Select a file and drop here" : file.path.split('/').last,
                style: const TextStyle(fontSize: 13, color: primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration _box({bool dashed = false}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: Colors.grey.shade300,
        style: dashed ? BorderStyle.solid : BorderStyle.solid,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        )
      ],
    );
  }

  Widget _gap() => const SizedBox(height: 18);
}
