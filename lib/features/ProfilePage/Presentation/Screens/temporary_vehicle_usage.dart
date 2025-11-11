import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class TemporaryVehicleUsage extends StatefulWidget {
  const TemporaryVehicleUsage({super.key});

  @override
  State<TemporaryVehicleUsage> createState() => _TemporaryVehicleUsageState();
}

class _TemporaryVehicleUsageState extends State<TemporaryVehicleUsage> {


  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickStartTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) setState(() => startTime = result);
  }

  Future<void> pickEndTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) setState(() => endTime = result);
  }

  Future<void> pickStartDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );
    if (result != null) setState(() => startDate = result);
  }

  Future<void> pickEndDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );
    if (result != null) setState(() => endDate = result);
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return "Select time";
    final hour = time.hourOfPeriod.toString().padLeft(2, "0");
    final minute = time.minute.toString().padLeft(2, "0");
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Select date";
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int m) {
    const months = [
      "", "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[m];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Temporary Vehicle Usage Form",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            const Text(
              "If your assigned vehicle is unavailable, record details of the temporary vehicle you're using today.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 20),


            Text(
              "CURRENT VEHICLE DETAILS",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: _shadowBox(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoText(label: "Vehicle Number:", value: "CA-123-XYZ"),
                        SizedBox(height: 6),
                        _InfoText(label: "Vehicle Model:", value: "Toyota Camry"),
                        SizedBox(height: 6),
                        _InfoText(label: "Type:", value: "Sedan"),
                        SizedBox(height: 6),
                        _InfoText(label: "Assigned Date:", value: "January 15 2024"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),


            Text(
              "TEMPORARY VEHICLE DETAILS",
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 18),

            _labelRequired("Vehicle Number"),
            _textField(vehicleNumberController, "Enter vehicle number"),
            const SizedBox(height: 22),

            _labelRequired("Vehicle Model"),
            _textField(modelController, "Enter vehicle Model"),
            const SizedBox(height: 22),


            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequired("Start Date"),
                      _pickerBox(
                        label: formatDate(startDate),
                        icon: Icons.calendar_month_outlined,
                        onTap: pickStartDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequired("End Date"),
                      _pickerBox(
                        label: formatDate(endDate),
                        icon: Icons.calendar_month_outlined,
                        onTap: pickEndDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),


            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequired("Start Time"),
                      _pickerBox(
                        label: formatTime(startTime),
                        icon: Icons.access_time,
                        onTap: pickStartTime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelRequired("End Time"),
                      _pickerBox(
                        label: formatTime(endTime),
                        icon: Icons.access_time,
                        onTap: pickEndTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            const Text(
              "Add Note (Optional)",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            _noteBox(),
            const SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text(
                  "Submit Form",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 25,)
          ],
        ),
      ),
    );
  }


  BoxDecoration _shadowBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: primaryColor.withOpacity(0.15),
          blurRadius: 20,
          offset: const Offset(0, 2),
        )
      ],
    );
  }

  Widget _labelRequired(String t) {
    return Row(
      children: [
        Text(t,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const Text(" *", style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _textField(TextEditingController c, String hint) {
    return Container(
      decoration: _shadowBox(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _pickerBox(
      {required String label,
        required IconData icon,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _shadowBox(),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color: label.contains("Select")
                        ? Colors.black38
                        : Colors.black87,
                    fontSize: 14)),
            Icon(icon, size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _noteBox() {
    return Container(
      decoration: _shadowBox(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(

        controller: noteController,
        maxLines: 4,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Add note here",
          hintStyle: TextStyle(color: Colors.black26),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}


class _InfoText extends StatelessWidget {
  final String label;
  final String value;

  const _InfoText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
