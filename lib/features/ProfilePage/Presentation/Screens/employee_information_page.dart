import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../Api/employee_information_repository.dart';
import '../../Model/employee_information_model.dart';

class EmployeeInformationScreen extends StatefulWidget {
  const EmployeeInformationScreen({super.key});

  @override
  State<EmployeeInformationScreen> createState() =>
      _EmployeeInformationScreenState();
}

class _EmployeeInformationScreenState
    extends State<EmployeeInformationScreen> {

  EmployeeInformationResponse? info;
  bool isLoading = true;
  String? error;

  final EmployeeInformationRepository _repo =
  EmployeeInformationRepository();

  @override
  void initState() {
    super.initState();
    _loadEmployeeInfo();
  }

  Future<void> _loadEmployeeInfo() async {
    try {
      final res = await _repo.fetchEmployeeInformation();
      setState(() {
        info = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load employee information";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Employee Information",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error!));
    }

    final data = info!;

    final infoList = [
      {
        'label': 'Employee ID',
        'value': data.employeeId,
        'icon': Icons.badge_outlined,
      },
      {
        'label': 'Full Name',
        'value': data.fullName,
        'icon': Icons.person_outline,
      },
      {
        'label': 'Employee Type',
        'value': data.employeeType,
        'icon': Icons.work_outline,
      },
      {
        'label': 'Company Name',
        'value': data.companyName,
        'icon': Icons.business_outlined,
      },
      {
        'label': 'Date Joined',
        'value': _formatDate(data.dateJoined),
        'icon': Icons.calendar_today_outlined,
      },
      {
        'label': 'Company Location',
        'value': data.companyLocation ?? "Not provided",
        'icon': Icons.location_on_outlined,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: infoList.map((item) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item['icon'] as IconData,
                      size: 18, color: Colors.black87),
                  const SizedBox(width: 8),
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['value'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(
                      "Non editable",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}";
    } catch (_) {
      return rawDate;
    }
  }
}
