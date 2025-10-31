import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weinber/core/constants/constants.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedIssueCategory;
  String? _currentAddress = "Fetching location...";

  final List<String> issueCategories = [
    'Technical Issue',
    'Login Problem',
    'App Crash',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await requestLocationPermission();
    await _getCurrentLocationAndAddress();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<void> _getCurrentLocationAndAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Location permission permanently denied")),
        );
        return;
      }

      // ✅ Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // ✅ Convert coordinates to address
      List<geocoding.Placemark> placemarks =
      await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";

        setState(() {
          _currentAddress = address;
          locationController.text = address;
        });
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Report an Issue",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // ✅ Date and Time Row
              Row(
                children: [
                  Expanded(
                    child: _buildLabelledField(
                      label: "Date",
                      required: true,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: _inputDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                              const Icon(Icons.calendar_today_outlined,
                                  size: 18, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLabelledField(
                      label: "Time",
                      required: true,
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: _inputDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedTime.format(context),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                              const Icon(Icons.access_time_outlined,
                                  size: 18, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _buildLabelledField(
                label: "Location",
                required: true,
                child: TextField(
                  style:
                      const TextStyle(fontSize: 13, color: Colors.black),

                  controller: locationController,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: _getCurrentLocationAndAddress,
                      icon: const Icon(Icons.location_on_outlined,
                          color: Colors.grey),
                    ),
                    hintText: "Fetching location...",
                    hintStyle:
                    const TextStyle(fontSize: 13, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    enabledBorder: _outlineBorder(),
                    focusedBorder: _outlineBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),


            _buildLabelledField(
              label: "Issue Category",
              required: true,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: _inputDecoration(), // This keeps outer rounded border
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: selectedIssueCategory),
                        onChanged: (value) {
                          selectedIssueCategory = value;
                        },
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Select or enter Issue type",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          border: InputBorder.none, // 👈 Removes all internal borders
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      color: Colors.white, // 👈 Ensures dropdown background is white
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      onSelected: (String value) {
                        setState(() {
                          selectedIssueCategory = value;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return issueCategories.map((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
            ),

              const SizedBox(height: 20),

              _buildLabelledField(
                label: "Description",
                required: true,
                child: TextField( style:
                const TextStyle(fontSize: 13, color: Colors.black87),
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Briefly describe the issue",
                    hintStyle:
                    const TextStyle(color: Colors.grey, fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    enabledBorder: _outlineBorder(),
                    focusedBorder: _outlineBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Attach Media",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              Container(
                width: width,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_outlined,
                        size: 36, color: Colors.grey),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Select a ',
                        style:
                        const TextStyle(color: Colors.black87, fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'file ',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text: 'and upload it here.',
                            style:
                            TextStyle(color: Colors.black87, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Supports PNG, JPEG Max file size 2MB.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Submit Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Submit Issue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelledField({
    required String label,
    required Widget child,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14
            ),
            children: required
                ? const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
  }
}
