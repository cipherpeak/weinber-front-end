import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../../core/constants/page_routes.dart';
import 'add_notes_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          // const SizedBox(height: 6),
          // const Text(
          //   "Notes",
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.w700,
          //     fontFamily: appFont,
          //   ),
          // ),
          //
          // const SizedBox(height: 20),

          /// 🔍 Search Bar
          Container(
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
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontFamily: appFont,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade500,
                  size: 22,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// 🧾 Tabs
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: appFont,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: appFont,
              ),
              indicatorWeight: 2.2,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(child: Text("Today's Notes")),
                Tab(child: Text("Future Notes")),
              ],
            ),
          ),

          const SizedBox(height: 18),

          /// TAB VIEWS
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.72,
            child: TabBarView(
              controller: _tabController,
              children: [
                /// TODAY NOTES
                _todayNotes(),

                /// FUTURE NOTES
                _futureNotes(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------
  // TODAY'S NOTES SECTION
  // ---------------------------
  Widget _todayNotes() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _addNotesCard(),

        const SizedBox(height: 15),

        /// Example Note 1
        GestureDetector(onTap: (){
          router.push(routerNotesDetailsPage);
        },
          child: _noteCard(
            title: "Follow-Up with Vendor",
            description:
                "Call the supplier to confirm the delivery timeline for the pending order...",
            bgColor: const Color(0xFFF8E6D1),
          ),
        ),

        const SizedBox(height: 15),

        /// Example Note 2
        _noteCard(
          title: "Weekly Expense Summary",
          description:
              "Prepare the consolidated expense sheet for the week, includin...",
          bgColor: const Color(0xFFE0EDFF),
        ),
      ],
    );
  }

  // ---------------------------
  // FUTURE NOTES SECTION
  // ---------------------------
  Widget _futureNotes() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _addNotesCard(),

        const SizedBox(height: 15),

        _noteCard(
          title: "Plan Team Meeting",
          description: "Schedule next week's internal review meeting...",
          bgColor: const Color(0xFFE8F8D6),
        ),
      ],
    );
  }

  // ---------------------------
  // ADD NOTES CARD
  // ---------------------------
  Widget _addNotesCard() {
    return GestureDetector(
      onTap: () {
        router.push(routerAddNotesPage);
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
        child: Row(
          children: const [
            CircleAvatar(
              radius: 16,
              backgroundColor: primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              "Add Notes",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: appFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // NOTE CARD WIDGET
  // ---------------------------
  Widget _noteCard({
    required String title,
    required String description,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: appFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              PopupMenuButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 1, child: Text("Edit")),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          // const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: appFont,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
