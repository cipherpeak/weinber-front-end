import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../Api/dax_task_repository.dart';
import '../../Model/dax_start_task_details_model.dart';

class DaxTaskInProgressScreen extends StatefulWidget {
  final int taskId;

  const DaxTaskInProgressScreen({super.key, required this.taskId});

  @override
  State<DaxTaskInProgressScreen> createState() =>
      _DaxTaskInProgressScreenState();
}

class _DaxTaskInProgressScreenState extends State<DaxTaskInProgressScreen> {
  final repo = DaxTaskRepository();

  bool loading = true;
  late DaxStartDetails data;
  final TextEditingController notesController = TextEditingController();

  final Map<String, String> siteMap = {
    "mq_dubai_showroom": "MG Dubai Showroom (SZR)",
    "mq_deira_service_center": "MG Deira Service Center",
    "mq_al_quoz_service_center": "MG Al Quoz Service Center",
    "mq_sharjah_showroom": "MG Sharjah Showroom",
    "mq_abu_dhabi_showroom": "MG Abu Dhabi Showroom",
    "mq_abu_dhabi_service_center": "MG Abu Dhabi Service Center",
    "mq_al_ain_showroom": "MG Al Ain Showroom",
    "mq_al_ain_service_center": "MG Al Ain Service Center",
    "mq_fujairah_showroom": "MG Fujairah Showroom",
    "mq_fujairah_service_center": "MG Fujairah Service Center",
    "premier_car_care_elite_motors": "Premier Car Care (Elite Motors)",
    "carnab_al_quoz": "Carnab (Al Quoz)",
    "emperor_garage": "Emperor Garage",
    "five_star_garage": "Five Star Garage",
    "golden_palace": "Golden Palace",
    "fos_automotive": "FOS Automotive",
    "office": "Office",
  };

  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await repo.fetchStartDetails(widget.taskId);

    completedCount = res.services.where((e) => e.completed).length;

    setState(() {
      data = res;
      loading = false;
    });
  }

  double get percentage => (completedCount / data.services.length) * 100;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 16),

            ...data.services.map(_checkCard),

            const SizedBox(height: 24),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () => _showCompleteTaskDialog(context),
            child: const Text(
              "End Task",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.serviceTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EACB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "In Progress",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBFA152),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...data.services.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "${e.name}${e.detail.isNotEmpty ? " - ${e.detail}" : ""}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 6),
              Text(
                siteMap[data.detailingSite] ?? data.detailingSite,
              ),

            ],
          ),

          const SizedBox(height: 6),

          Text(
            "Started at: ${TimeOfDay.fromDateTime(data.createdAt).format(context)}",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= CHECKLIST CARD =================

  Widget _checkCard(DaxServiceCheck s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.grey.shade300, width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${s.name}${s.detail.isNotEmpty ? " - ${s.detail}" : ""}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          /// Checkbox
          Transform.scale(
            scale: 1.05,
            child: Checkbox(
              value: s.completed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              activeColor: const Color(0xFF4F7DF3),
              onChanged: (v) async {
                if (v == true && !s.completed) {
                  try {
                    await repo.completeService(s.id);

                    // 🔥 REFRESH FROM SERVER AGAIN
                    await _load();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Service marked completed")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },


            ),
          ),
        ],
      ),
    );
  }

  // Widget _progressUpdateSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "PROGRESS UPDATE",
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w700,
  //           color: Colors.grey,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  //         decoration: _box(),
  //         child: const TextField(
  //           maxLines: 3,
  //           decoration: InputDecoration(
  //             hintText: "Add progress notes here",
  //             border: InputBorder.none,
  //             enabledBorder: InputBorder.none,
  //             focusedBorder: InputBorder.none,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16),
    ],
  );

  // ================= END TASK DIALOG =================

  void _showCompleteTaskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Complete Task",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Final Comments (Optional)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Add any final notes about the completed task",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,


                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white),
                    label: const Text(
                      "Mark Task as Completed",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    onPressed: () async {
                      try {
                        await repo.completeEntireTask(
                          widget.taskId,
                          notesController.text,
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Task completed successfully")),
                        );

                        // 🔥 go back to task list and refresh
                        Navigator.pop(context);
                        router.go(routerDaxTaskPage);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
