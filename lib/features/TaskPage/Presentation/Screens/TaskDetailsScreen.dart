import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../Widgets/task_details_row.dart';

class TaskDetailsPage extends ConsumerStatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  ConsumerState<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends ConsumerState<TaskDetailsPage> {
  String _currentAddress = "Fetching location...";

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _startTracking();
  }


  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted ) {
      await Permission.locationWhenInUse.request();
    }

  }

  Future<void> _startTracking() async {
    var permission;
    bool serviceStatus = await Geolocator.isLocationServiceEnabled();
    serviceStatus = await Geolocator.isLocationServiceEnabled();
    if (serviceStatus) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {

          await Future.delayed(const Duration(milliseconds: 200));

        } else if (permission == LocationPermission.deniedForever) {

          await Future.delayed(const Duration(milliseconds: 200));

        }
      }
    } else {

      await Future.delayed(const Duration(milliseconds: 200));

    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high)
    );


    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      setState(() {
        _currentAddress =
        "${place.street}, ${place.locality}, ${place.country}";
      });
    }



  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Task Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                      "Task Assigned",
                      "Car Wash",
                      myWidth: screenWidth,
                      bold: true,
                    ),
                    buildDetailRow(
                      "Customer Name",
                      "Robert Vincent",
                      myWidth: screenWidth,
                      bold: true,
                    ),
                    buildDetailRow(
                      "Scheduled Time",
                      "02:00 PM",
                      myWidth: screenWidth,
                      bold: true,
                    ),
                    buildDetailRow(
                      "Vehicle",
                      "Toyota Camry - ABC 123",
                      myWidth: screenWidth,
                      bold: true,
                    ),
                    buildDetailRow(
                      "Task Type",
                      "Exterior + Interior Cleaning",
                      myWidth: screenWidth,
                    ),
                    const SizedBox(height: 8),

                    buildDetailRow(
                      "Location",
                      _currentAddress,
                      myWidth: screenWidth,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Task Notes",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        // color: Color(0xFFF4F4F4),
                      ),
                      child: const Text(
                        "Please ensure to confirm vehicle condition before starting the wash. Take before and after photos.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFFEAF9EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Priority: Normal",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 13
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(routerStartTaskDetailsPage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Start Task",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
