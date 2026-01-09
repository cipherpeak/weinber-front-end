import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../../../../core/constants/constants.dart';
import '../../../Api/vehicle_repository.dart';
import '../../../Model/vehicle_details_response.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  VehicleDetailsResponse? vehicleData;
  bool isLoading = true;
  String? error;

  final VehicleRepository _repo = VehicleRepository();

  @override
  void initState() {
    super.initState();
    _loadVehicleDetails();
  }

  Future<void> _loadVehicleDetails() async {
    try {
      final res = await _repo.fetchVehicleDetails();
      if (!mounted) return;
      setState(() {
        vehicleData = res;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = "Failed to load vehicle details";
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

    final current = vehicleData!.currentVehicle;
    final temporary = vehicleData!.temporaryVehicle;

//temporary overrides current
    final activeVehicle = temporary ?? current;

    if (activeVehicle == null) {
      return const Center(child: Text("No vehicle assigned"));
    }

    return buildVehicleUI(activeVehicle);

  }

  Widget buildVehicleUI(VehicleData vehicle) {
    final issues = vehicle.reportedIssues;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vehicleData!.temporaryVehicle != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Text(
                "Temporary vehicle in use",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            SizedBox(height: 10,)
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              // Vehicle image
              Container(
                width: 120,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: vehicle.vehicleImage != null
                        ? NetworkImage(vehicle.vehicleImage!)
                        : const AssetImage("assets/images/profile.png")
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _VehicleDetailText(
                        label: "Vehicle Number:",
                        value: _v(vehicle.vehicleNumber)),
                    const SizedBox(height: 6),
                    _VehicleDetailText(
                        label: "Vehicle Model:", value: _v(vehicle.model)),
                    const SizedBox(height: 6),
                    _VehicleDetailText(
                        label: "Type:", value: _v(vehicle.vehicleType)),
                    const SizedBox(height: 6),
                    _VehicleDetailText(
                        label: "Assigned Date:",
                        value: _format(vehicle.assignedDate)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          _section("REPORTED VEHICLE ISSUES"),
          const SizedBox(height: 15),

          if (issues.isEmpty)
            const Text("No issues reported",
                style: TextStyle(color: Colors.black45))
          else
            ...issues.map((e) => _buildApiIssueCard(e)),


          const SizedBox(height: 25),

          if (vehicleData!.temporaryVehicle == null) ...[
            SizedBox(
                height: 45,
                width: double.infinity,
                child:  ElevatedButton(
                  onPressed: () async {
                    final res = await router.push(routerTemporaryVehicleUsagePage);

                    if (res == true) {
                      _loadVehicleDetails();
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                  child: Text(
                    vehicleData!.temporaryVehicle == null
                        ? "Use Temporary Vehicle"
                        : "View / Change Temporary Vehicle",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ),
          ],

          const SizedBox(height: 25),
          _section("COMPLIANCE & FINES"),

          GestureDetector(
            onTap: () {
              router.push(routerFinesAndPenaltiesPage);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 🔴Left icon box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFFE57373),
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // 📝 Text section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Fines & Penalties",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "View history of traffic violations",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          const SizedBox(height: 25),
          _section("ADDITIONAL INFORMATION"),
          const SizedBox(height: 20),

          _InfoField(
            icon: Icons.calendar_today_outlined,
            label: "Insurance Expiry Date",
            value: _format(vehicle.insuranceExpiryDate),
            isEditable: false,
          ),

          const SizedBox(height: 25),

          _InfoField(
            icon: Icons.local_gas_station_outlined,
            label: "Fuel Type",
            value: _v(vehicle.fuelType),
            isEditable: false,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _v(String? v) => (v == null || v.isEmpty) ? "Not provided" : v;

  String _format(String? d) {
    if (d == null || d.isEmpty) return "Not provided";
    try {
      final dt = DateTime.parse(d);
      return "${dt.day}-${dt.month}-${dt.year}";
    } catch (_) {
      return d;
    }
  }

  Widget _section(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
      ),
    );
  }


  Widget _buildApiIssueCard(VehicleIssue issue) {
    final statusColor =
    issue.status.toLowerCase() == "resolved" ? Color(0xFF5ED18F) : Color(0xFFFFC764);

    return _buildIssueCard({
      "title": issue.title,
      "status": issue.status,
      "statusColor": statusColor,
      "user": issue.reportedBy,
      "date": issue.date,
    });
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
