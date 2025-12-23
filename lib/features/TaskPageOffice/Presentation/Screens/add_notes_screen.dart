import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              child: const Text(
                "Save Notes",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel(label: "Date"),
            const SizedBox(height: 6),
            _dateField(),

            const SizedBox(height: 16),

            const _FieldLabel(label: "Title"),
            const SizedBox(height: 6),
            _textField(
              controller: titleController,
              hint: "Enter title for your note",
            ),

            const SizedBox(height: 16),

            const _FieldLabel(label: "Note Description"),
            const SizedBox(height: 6),
            Expanded(child: _descriptionField()),
          ],
        ),
      ),
    );
  }

  // ---------------- DATE PICKER FIELD ----------------
  Widget _dateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: _boxDecoration(),
        child: Row(
          children: [
            Text(
              selectedDate == null
                  ? "Select date"
                  : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
              style: TextStyle(
                color:
                selectedDate == null ? Colors.grey : Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }

  // ---------------- NORMAL TEXT FIELD ----------------
  Widget _textField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  // ---------------- DESCRIPTION FIELD ----------------
  Widget _descriptionField() {
    return Container(
      decoration: _boxDecoration(),
      child: TextField(
        controller: descriptionController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: "Enter description",
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14),
        ),
      ),
    );
  }


  // ---------------- HELPERS ----------------
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  void _saveNote() {
    // TODO: API / Local save
    Navigator.pop(context);
  }
}

/// FIELD LABEL
class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        children: const [
          TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}


