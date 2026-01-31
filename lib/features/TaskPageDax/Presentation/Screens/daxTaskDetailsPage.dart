import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';
import '../../Api/dax_task_repository.dart';
import '../../Model/dart_task_details_model.dart';

class DaxTaskDetailsScreen extends StatefulWidget {
  final int taskId;
  final String status;

  const DaxTaskDetailsScreen({super.key, required this.taskId, required this.status});

  @override
  State<DaxTaskDetailsScreen> createState() => _DaxTaskDetailsScreenState();
}

class _DaxTaskDetailsScreenState extends State<DaxTaskDetailsScreen> {
  final repo = DaxTaskRepository();

  bool loading = true;
  String? error;
  DaxTaskDetails? data;

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


  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await repo.fetchDaxTaskDetails(widget.taskId);
      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceFirst("Exception: ", "");
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    }

    final t = data!;

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
        child: _detailsCard(t),
      ),
      bottomNavigationBar: widget.status == "completed"
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () async {
            if (widget.status == "not_started") {
              try {
                await repo.startDaxTask(widget.taskId);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  ),
                );
                return;
              }
            }

            if (!context.mounted) return;

            router.push(
              routerDaxTaskInProgressPage,
              extra: {
                "taskId": widget.taskId,
                "status": widget.status,
              },
            );
          },
          child: Text(
            widget.status == "not_started"
                ? "Start Task"
                : "View Task",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),

    );
  }

  Widget _detailsCard(DaxTaskDetails t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.serviceTitle,
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),

          const SizedBox(height: 12),

          ...t.services.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              "${s.serviceName} ${s.detail.isNotEmpty ? '- ${s.detail}' : ''}",
              style: const TextStyle(fontSize: 13),
            ),
          )),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 6),
              Text(siteMap[t.detailingSite] ?? t.detailingSite),
            ],
          ),

          const SizedBox(height: 16),

          const Text("Remarks",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          Container(width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: _innerBox(),
            child: Text(t.remarks),
          ),

          const SizedBox(height: 20),

          const Text("VEHICLE INFORMATION",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600)),

          const SizedBox(height: 10),

          _infoRow("Chassis Number", t.chassisNo),
          _infoRow("Vehicle Model", t.vehicleModel),

          if (t.invoiceImage != null) ...[
            const SizedBox(height: 16),
            const Text("Invoice / PR"),
            const SizedBox(height: 8),
            Image.network(t.invoiceImage!),
          ]
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 13),
          children: [
            TextSpan(text: "$label : "),
            TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 4))
    ],
  );

  BoxDecoration _innerBox() => BoxDecoration(
    color: const Color(0xFFF8F9FB),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.grey.shade300),
  );
}
