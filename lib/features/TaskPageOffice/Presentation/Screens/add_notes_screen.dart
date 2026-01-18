import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../Api/notes_repo.dart';
import '../../Model/notes_detail_model.dart';


class AddNoteScreen extends StatefulWidget {
  final NoteDetail? note; // 🔥 if null → add, if not null → edit

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  bool isSaving = false;

  final repo = NotesRepository();

  bool get isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    /// ✏️ PREFILL IF EDIT MODE
    if (isEdit) {
      final n = widget.note!;
      titleController.text = n.title;
      descriptionController.text = n.description;
      selectedDate = DateTime.parse(n.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      /// APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Edit Note" : "Add Note",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              child: isSaving
                  ? const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                isEdit ? "Update" : "Save",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),

      /// BODY
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
                color: selectedDate == null ? Colors.grey : Colors.black87,
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
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  // ---------------- SAVE (ADD / EDIT) ----------------
  Future<void> _saveNote() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final date =
          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2,'0')}-${selectedDate!.day.toString().padLeft(2,'0')}";

      if (isEdit) {
        /// ✏️ EDIT NOTE
        await repo.editNote(
          id: widget.note!.id,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          date: date,
        );
      } else {
        /// ➕ ADD NOTE
        await repo.createNote(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          date: date,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
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
          TextSpan(text: " *", style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }
}
