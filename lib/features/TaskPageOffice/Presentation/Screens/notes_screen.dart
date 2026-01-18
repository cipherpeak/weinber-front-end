import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../../core/constants/page_routes.dart';
import '../../Model/notes_response_model.dart';
import '../../Api/notes_repo.dart';
import '../Provider/notes_notifier.dart';
import 'add_notes_screen.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesNotifierProvider);

    return notesState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (notesData) => _ui(notesData),
    );
  }

  // ================= UI =================

  Widget _ui(NotesResponse notesData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          const SizedBox(height: 10),
          _tabs(),
          const SizedBox(height: 18),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: TabBarView(
              controller: _tabController,
              children: [
                _notesList(notesData.todayNotes, true),
                _notesList(notesData.futureNotes, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SEARCH =================

  Widget _searchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        cursorColor: primaryColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "Search your notes",
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 22),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  // ================= TABS =================

  Widget _tabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryColor,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 2.2,
        tabs: const [
          Tab(text: "Today's Notes"),
          Tab(text: "Future Notes"),
        ],
      ),
    );
  }

  // ================= NOTES LIST =================

  Widget _notesList(List<OfficeNote> notes, bool isToday) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _addNotesCard(),
        const SizedBox(height: 15),

        if (notes.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text("No notes found")),
          ),

        ...notes.map((n) => Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () {
              router.push(routerNotesDetailsPage, extra: n.id);
            },
            child: _noteCard(
              note: n,
              bgColor:
              isToday ? const Color(0xFFF8E6D1) : const Color(0xFFE8F8D6),
            ),
          ),
        )),
      ],
    );
  }

  // ================= ADD NOTES =================

  Widget _addNotesCard() {
    return GestureDetector(
      onTap: () async {
        final res = await router.push(routerAddNotesPage);
        if (res == true) {
          ref.read(notesNotifierProvider.notifier).refresh();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              "Add Notes",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ================= NOTE CARD =================

  Widget _noteCard({required OfficeNote note, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(note.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == "edit") _editNote(note.id);
                  if (v == "delete") _deleteNote(note.id);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "edit", child: Text("Edit")),
                  PopupMenuItem(
                    value: "delete",
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),

            ],
          ),
          const SizedBox(height: 6),
          Text(
            note.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  // ================= ACTIONS =================
  Future<void> _editNote(int noteId) async {
    try {
      final repo = NotesRepository();

      // show loader
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final noteDetail = await repo.fetchNoteDetails(noteId);

      if (!mounted) return;

      // close loader SAFELY
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      // wait one frame before navigation (VERY IMPORTANT)
      await Future.delayed(const Duration(milliseconds: 100));

      final res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddNoteScreen(note: noteDetail),
        ),
      );

      if (res == true) {
        ref.read(notesNotifierProvider.notifier).refresh();
      }
    } catch (e) {
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _deleteNote(int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Delete note?"),
        content: const Text("This action cannot be undone"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx), // ✅ close only dialog
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogCtx); // ✅ close dialog first

              try {
                // show loader
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  useRootNavigator: true,
                  builder: (_) =>
                  const Center(child: CircularProgressIndicator()),
                );

                await NotesRepository().deleteNote(id);

                if (!mounted) return;

                // close loader safely
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                ref.read(notesNotifierProvider.notifier).refresh();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Note deleted")),
                );

              } catch (e) {
                if (mounted &&
                    Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

}
