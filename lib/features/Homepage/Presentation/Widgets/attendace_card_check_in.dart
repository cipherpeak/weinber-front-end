import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

Widget attendanceCardCheckIn() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black12.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Column(
      children: [
        /// Attendance Status Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Status: ',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Pending',
                style: TextStyle(
                  color: Color(0xFFE74C3C),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Check-in / Check-out times
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: const [
                  Text(
                    'Checked In at:',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '--:-- AM',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ],
              ),

              // Check In Circle Button
              GestureDetector(onTap: (){
                router.push(routerCheckInFirstPage);
              },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFDAA3FF), Color(0xFFFFBEBE)],
                      stops: [0.0, 1.0],
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Check In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.black54,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: const [
                  Text(
                    'Checked Out at:',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '--:-- PM',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
