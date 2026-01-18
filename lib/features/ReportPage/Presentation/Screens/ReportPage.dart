import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';


import '../../../../utils/Common Widgets/build_labelled_field.dart';
import '../../Api/report_issue_repo.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportIssueRepository _repo = ReportIssueRepository();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedIssueCategory;
  File? mediaFile;
  bool isSubmitting = false;

  final List<String> issueCategories = [
    'Maintenance',
    'Technical Issue',
    'Login Problem',
    'App Crash',
    'Other',
  ];

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  // ================= LOCATION =================

  Future<void> _initializeLocation() async {
    await Permission.locationWhenInUse.request();
    await _getCurrentLocationAndAddress();
  }

  Future<void> _getCurrentLocationAndAddress() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<geocoding.Placemark> placemarks =
      await geocoding.placemarkFromCoordinates(
          position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";

        setState(() {
          locationController.text = address;
        });
      }
    } catch (e) {
      debugPrint("Location error => $e");
    }
  }

  // ================= HELPERS =================

  String _apiDate(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _apiTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  // ================= PICKERS =================

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );
    if (d != null) setState(() => selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (t != null) setState(() => selectedTime = t);
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        mediaFile = File(result.files.single.path!);
      });
    }
  }

  // ================= SUBMIT =================

  Future<void> _submitIssue() async {
    if (selectedIssueCategory == null ||
        descriptionController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      setState(() => isSubmitting = true);

      await _repo.reportIssue(
        date: _apiDate(selectedDate),
        time: _apiTime(selectedTime),
        location: locationController.text.trim(),
        issueCategory: selectedIssueCategory!,
        description: descriptionController.text.trim(),
        mediaFile: mediaFile,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Issue reported successfully")),
      );

      router.go(routerHomePage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to report issue")),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Report an Issue",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),

              const SizedBox(height: 20),

              // DATE & TIME
              Row(
                children: [
                  Expanded(
                    child: buildLabelledField(
                      label: "Date",
                      required: true,
                      child: _pickerBox(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        Icons.calendar_today_outlined,
                        _pickDate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildLabelledField(
                      label: "Time",
                      required: true,
                      child: _pickerBox(
                        selectedTime.format(context),
                        Icons.access_time_outlined,
                        _pickTime,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // LOCATION
              buildLabelledField(
                label: "Location",
                required: true,
                child: TextField(
                  controller: locationController,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on_outlined),
                      onPressed: _getCurrentLocationAndAddress,
                    ),
                    enabledBorder: _border(),
                    focusedBorder: _border(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ISSUE CATEGORY
              buildLabelledField(
                label: "Issue Category",
                required: true,
                child: Container(
                  decoration: _box(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedIssueCategory,
                      hint: const Text("Select issue category"),
                      isExpanded: true,
                      items: issueCategories
                          .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedIssueCategory = v),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // DESCRIPTION
              buildLabelledField(
                label: "Description",
                required: true,
                child: TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Briefly describe the issue",
                    enabledBorder: _border(),
                    focusedBorder: _border(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ATTACH MEDIA
              const Text("Attach Media",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: _pickMedia,
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(16),
                  decoration: _box(),
                  child: Column(
                    children: [
                      const Icon(Icons.cloud_upload_outlined, size: 34),
                      const SizedBox(height: 8),
                      Text(
                        mediaFile == null
                            ? "Select a file and upload here"
                            : mediaFile!.path.split('/').last,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // SUBMIT
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitIssue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text("Submit Issue",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGETS =================

  Widget _pickerBox(String text, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: _box(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(text), Icon(icon, size: 18)],
        ),
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade300),
    color: Colors.white,
  );

  OutlineInputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.grey.shade300),
  );
}
