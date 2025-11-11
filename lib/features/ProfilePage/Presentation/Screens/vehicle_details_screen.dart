import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../../../core/constants/constants.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final List<Map<String, dynamic>> issues = [
    {
      "title": "Engine Waring Light",
      "status": "In Progress",
      "statusColor": Color(0xFFFFC764),
      "user": "John Doe",
      "date": "05 July 2025",
    },
    {
      "title": "Flat Tire on Front Tire",
      "status": "Resolved",
      "statusColor": Color(0xFF5ED18F),
      "user": "Rachel Karl",
      "date": "21 May 2025",
    },
    {
      "title": "Broken Side Mirror",
      "status": "Resolved",
      "statusColor": Color(0xFF5ED18F),
      "user": "Rick John",
      "date": "15 August 2024",
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
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vehicle Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle image
                Container(
                  width: 120,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/profile.png"),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),

                // Vehicle info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _VehicleDetailText(
                        label: "Vehicle Number:",
                        value: "CA-123-XYZ",
                      ),
                      SizedBox(height: 6),
                      _VehicleDetailText(
                        label: "Vehicle Model:",
                        value: "Toyota Camry",
                      ),
                      SizedBox(height: 6),
                      _VehicleDetailText(label: "Type:", value: "Sedan"),
                      SizedBox(height: 6),
                      _VehicleDetailText(
                        label: "Assigned Date:",
                        value: "January 15 2024",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.history, size: 22, color: Colors.black87),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Previous Vehicle Details",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "REPORTED VEHICLE ISSUES",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 15),

            ...issues.map((issue) => _buildIssueCard(issue)).toList(),

            const SizedBox(height: 25),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  router.push(routerTemporaryVehicleUsagePage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                ),
                child: const Text(
                  "Temporary Vehicle Usage",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "ADDITIONAL INFORMATION",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),

            // Vehicle Expiry Date field
            const _InfoField(
              icon: Icons.calendar_today_outlined,
              label: "Vehicle Expiry Date",
              value: "12 December 2027",
              isEditable: false,
            ),
            const SizedBox(height: 25),
            const _InfoField(
              icon: Icons.calendar_today_outlined,
              label: "Insurance Expiry Date",
              value: "12 December 2027",
              isEditable: false,
            ),
            const SizedBox(height: 25),
            const _InfoField(
              icon: Icons.local_gas_station_outlined,
              label: "Fuel Type",
              value: "Petrol",
              isEditable: false,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard(Map<String, dynamic> issue) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    issue["title"],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: issue["statusColor"].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        issue["status"],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: issue["statusColor"],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // User + date
              Text(
                "By ${issue["user"]} · ${issue["date"]}",
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEditable;

  const _InfoField({
    required this.icon,
    required this.label,
    required this.value,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (!isEditable)
                const Text(
                  "Non editable",
                  style: TextStyle(fontSize: 11, color: Colors.black26),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VehicleDetailText extends StatelessWidget {
  final String label;
  final String value;

  const _VehicleDetailText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "$label ",
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: "\t$value",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
