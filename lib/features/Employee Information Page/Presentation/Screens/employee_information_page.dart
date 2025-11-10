import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';

class EmployeeInformationScreen extends StatelessWidget {
   EmployeeInformationScreen({super.key});


  final List<Map<String, dynamic>> infoList = [
    {
      'label': 'Employee ID',
      'value': 'EMP-00-123',
      'icon': Icons.badge_outlined,
    },
    {
      'label': 'Full Name',
      'value': 'John Doe',
      'icon': Icons.person_outline,
    },
    {
      'label': 'Date of Joining',
      'value': '15 August 2022',
      'icon': Icons.calendar_today_outlined,
    },
    {
      'label': 'Department',
      'value': 'Car Service',
      'icon': Icons.apartment_outlined,
    },
    {
      'label': 'Profession',
      'value': 'Field Service Specialist',
      'icon': Icons.work_outline,
    },
    {
      'label': 'Reporting Manager',
      'value': 'Lee Williamson',
      'icon': Icons.supervisor_account_outlined,
    },
    {
      'label': 'Company Name',
      'value': 'Advantage International General Trading LLC',
      'icon': Icons.business_outlined,
    },
    {
      'label': ' Branch Location',
      'value': 'WG 04 Ras Al Khor\nArea 1, PO Box\nUAE',
      'icon': Icons.location_on_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
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
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: infoList.map((item) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + Icon Row
                Row(
                  children: [
                    Icon(item['icon'], size: 18, color: Colors.black87),
                    const SizedBox(width: 8),
                    Text(
                      item['label'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Field Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Value
                      Expanded(
                        child: Text(
                          item['value'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Non editable tag

                       Text(
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
      ),
    );
  }
}
