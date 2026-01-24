import 'package:flutter/material.dart';
import '../../../../../core/constants/constants.dart';
import '../../../Api/vehicle_repository.dart';
import '../../../Model/reportedVehicleIssueModel.dart';


class ReportedVehicleDetailsPage extends StatefulWidget {
  const ReportedVehicleDetailsPage({super.key});

  @override
  State<ReportedVehicleDetailsPage> createState() =>
      _ReportedVehicleDetailsPageState();
}

class _ReportedVehicleDetailsPageState
    extends State<ReportedVehicleDetailsPage> {

  final repo = VehicleRepository();

  bool loading = true;
  List<ReportedVehicleIssue> issues = [];
  int? expandedId;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    try {
      final res = await repo.fetchReportedVehicleIssues();
      if (!mounted) return;

      setState(() {
        issues = res;
        loading = false;
      });
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reported Vehicle Issues",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : issues.isEmpty
          ? const Center(child: Text("No reports found"))
          : ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: issues.length,
        itemBuilder: (context, index) {
          final issue = issues[index];
          final isExpanded = expandedId == issue.id;

          return _issueCard(issue, isExpanded);
        },
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _issueCard(ReportedVehicleIssue issue, bool expanded) {
    final statusColor =
    issue.status.toLowerCase() == "open"
        ? Colors.orange
        : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Expanded(
                child: Text(
                  issue.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  issue.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            "Reported on ${issue.reportedDate}",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 10),

          /// BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  expandedId = expanded ? null : issue.id;
                });
              },
              child: Text(
                expanded ? "Hide details" : "View details",
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// EXPANDED VIEW
          if (expanded) ...[
            const Divider(),

            if (issue.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  issue.image!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 10),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              issue.description,
              style: const TextStyle(color: Colors.black87),
            ),
          ]
        ],
      ),
    );
  }
}
