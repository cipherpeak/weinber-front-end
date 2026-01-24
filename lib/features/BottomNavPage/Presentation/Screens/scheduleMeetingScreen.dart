import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../Api/meeting_repository.dart';
import '../../Model/meeting_employee.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  const ScheduleMeetingScreen({super.key});

  @override
  State<ScheduleMeetingScreen> createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final agendaController = TextEditingController();
  final searchController = TextEditingController();

  final repo = MeetingRepository();
  final FocusNode _searchFocus = FocusNode();


  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<MeetingEmployee> allEmployees = [];
  List<MeetingEmployee> filteredEmployees = [];
  List<MeetingEmployee> selectedEmployees = [];

  bool loadingEmployees = true;
  bool creatingMeeting = false;
  bool showDropdown = false;


  @override
  void initState() {
    super.initState();
    _loadEmployees();
    searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }


  Future<void> _loadEmployees() async {
    try {
      final res = await repo.fetchEmployees();
      if (!mounted) return;

      setState(() {
        allEmployees = res;
        filteredEmployees = res;
        loadingEmployees = false;
      });
    } catch (e) {
      loadingEmployees = false;
      debugPrint(e.toString());
    }
  }

  void _onSearch() {
    final q = searchController.text.toLowerCase();

    setState(() {
      showDropdown = true;
      filteredEmployees = allEmployees
          .where((e) => e.name.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Schedule Meeting",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: appFont,
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: creatingMeeting ? null : _createMeeting,
            child: creatingMeeting
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              "Schedule Meeting",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: appFont,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: GestureDetector(
        behavior:  HitTestBehavior.translucent,
        onTap: (){
          FocusScope.of(context).unfocus(); // close keyboard
          if (showDropdown) {
            setState(() => showDropdown = false); // close dropdown
          }
        },

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Add details and choose attendees",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8F96A3),
                  fontFamily: appFont,
                ),
              ),

              const SizedBox(height: 20),

              _label("Meeting Title"),
              _textField(titleController, "Enter the meeting title"),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(child: _datePicker()),
                  const SizedBox(width: 12),
                  Expanded(child: _timePicker()),
                ],
              ),

              const SizedBox(height: 14),

              _label("Meeting Location"),
              _textField(locationController, "Enter the meeting location"),

              const SizedBox(height: 18),

              _label("Select Attendees"),
              _searchField(),

              if (loadingEmployees)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                _employeeDropdown(),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: selectedEmployees
                    .map((e) => _memberChip(e))
                    .toList(),
              ),

              const SizedBox(height: 22),

              _label("Agenda", required: false),
              _agendaField(),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- API ACTION ----------------

  Future<void> _createMeeting() async {
    if (titleController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        selectedEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields")),
      );
      return;
    }

    setState(() => creatingMeeting = true);

    try {
      final date =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

      //  24 hour format
      final time =
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

      await repo.createMeeting(
        title: titleController.text.trim(),
        date: date,
        time: time,
        location: locationController.text.trim(),
        attendees: selectedEmployees.map((e) => e.id).toList(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Meeting scheduled successfully")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => creatingMeeting = false);
    }
  }

  // ---------------- EMPLOYEE PICK ----------------

  Widget _employeeDropdown() {
    if (!showDropdown) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: loadingEmployees
          ? const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      )
          : filteredEmployees.isEmpty
          ? const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("No employees found")),
      )
          : ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: filteredEmployees.length,
        itemBuilder: (context, index) {
          final e = filteredEmployees[index];
          final alreadySelected =
          selectedEmployees.any((x) => x.id == e.id);

          return ListTile(
            dense: true,
            title: Text(e.name),
            trailing: alreadySelected
                ? const Icon(Icons.check, color: primaryColor)
                : null,
            onTap: () {
              if (!alreadySelected) {
                setState(() => selectedEmployees.add(e));
              }
              searchController.clear();
              filteredEmployees = allEmployees;
              showDropdown = false;
            },
          );
        },
      ),
    );
  }


  // ---------------- UI HELPERS ----------------

  Widget _memberChip(MeetingEmployee emp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 12, color: primaryColor),
          ),
          const SizedBox(width: 6),
          Text(
            emp.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: appFont,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              setState(() => selectedEmployees.removeWhere((x) => x.id == emp.id));
            },
            child: const Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ------------------ Widgets ------------------

  Widget _label(String text, {bool required = true}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: appFont,
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
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: const TextStyle(
            color: Color(0xFFB0B5C0),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _agendaField() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: _boxDecoration(),
      child: TextField(
        controller: agendaController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: "Briefly describe the agenda of the meeting",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintStyle: TextStyle(
            color: Color(0xFFB0B5C0),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return GestureDetector(
      onTap: () {
        setState(() => showDropdown = !showDropdown);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                focusNode: _searchFocus,
                controller: searchController,
                onTap: () {
                  setState(() => showDropdown = true);
                },
                decoration: const InputDecoration(
                  hintText: "Select members for the meeting",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0xFFB0B5C0),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            AnimatedRotation(
              turns: showDropdown ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }



  Widget _datePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Text(
              selectedDate == null
                  ? "Choose date"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(
                color: selectedDate == null
                    ? const Color(0xFFB0B5C0)
                    : Colors.black87,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            const Icon(Icons.calendar_month_outlined,
                size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _timePicker() {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Text(
              selectedTime == null
                  ? "Choose time"
                  : selectedTime!.format(context),
              style: TextStyle(
                color: selectedTime == null
                    ? const Color(0xFFB0B5C0)
                    : Colors.black87,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            const Icon(Icons.access_time,
                size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ------------------ Helpers ------------------

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    );
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (d != null) setState(() => selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => selectedTime = t);
  }
}
