import 'package:flutter/material.dart';
import '../../../Api/leave_repo.dart';
import '../../../Model/leave_detail_model.dart';

class LeaveDetailsScreen extends StatefulWidget {
  final int leaveId;
  const LeaveDetailsScreen({super.key, required this.leaveId});

  @override
  State<LeaveDetailsScreen> createState() => _LeaveDetailsScreenState();
}

class _LeaveDetailsScreenState extends State<LeaveDetailsScreen> {
  final repo = LeaveRepository();
  LeaveDetail? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await repo.fetchLeaveDetails(widget.leaveId);
      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      loading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Leave Details", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : _ui(),
    );
  }

  Widget _ui() {
    final l = data!;
    final statusColor = _statusColor(l.status);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [

        /// 🔹 HEADER CARD
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEEF2FF), Color(0xFFFFFFFF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
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
                    child: Text(
                      l.reason,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      l.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 10),

              _iconRow(Icons.person, "Employee", l.employeeName),
              _iconRow(Icons.category_outlined, "Leave Type", l.category),
              _iconRow(Icons.calendar_today_outlined, "From", l.startDate),
              _iconRow(Icons.event_outlined, "To", l.endDate),
              _iconRow(Icons.timelapse_outlined, "Total Days", l.totalDays),
            ],
          ),
        ),

        const SizedBox(height: 18),

        /// 🔹 DETAILS CARD
        _sectionCard(
          title: "Travel & Stay Information",
          children: [
            _iconRow(Icons.flight_takeoff, "Passport From", l.passportFrom),
            _iconRow(Icons.flight_land, "Passport To", l.passportTo),
            _iconRow(Icons.home_work_outlined, "Address During Leave", l.addressDuringLeave),
          ],
        ),

        const SizedBox(height: 16),

        /// 🔹 APPROVAL CARD
        _sectionCard(
          title: "Approval Information",
          children: [
            _iconRow(Icons.badge_outlined, "Employee ID", l.employeeId),
            _iconRow(Icons.verified_user_outlined, "Approved By",
                l.approvedByName?.isEmpty ?? true ? "Not assigned" : l.approvedByName!),
            if (l.rejectionReason.isNotEmpty)
              _iconRow(Icons.cancel_outlined, "Rejection Reason", l.rejectionReason),
          ],
        ),

        const SizedBox(height: 16),

        /// 🔹 ATTACHMENTS
        _sectionCard(
          title: "Attachments",
          children: [
            _attachmentTile("Ticket Eligibility", l.ticketEligibility),
            _attachmentTile("Attachment File", l.attachmentUrl),
            _attachmentTile("Signature", l.signatureUrl),
          ],
        ),
      ],
    );
  }

  // ================= COMPONENTS =================

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...children
        ],
      ),
    );
  }

  Widget _iconRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black45)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentTile(String title, String? url) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.attach_file, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(
        url == null || url.isEmpty ? "Not available" : "Tap to view",
        style: const TextStyle(fontSize: 12),
      ),
      trailing: url == null || url.isEmpty
          ? const Icon(Icons.block, color: Colors.grey)
          : const Icon(Icons.open_in_new, color: Colors.green),
      onTap: url == null || url.isEmpty ? null : () {
        // 🔜 open file or image viewer
      },
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "rejected":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}
