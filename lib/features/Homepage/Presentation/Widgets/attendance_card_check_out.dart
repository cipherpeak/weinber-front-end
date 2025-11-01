import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

Widget attendanceCardCheckOut() {
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
                color: const Color(0xFFFAF1DA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Checked in',
                style: TextStyle(
                  color: Color(0xFFC19D3D),
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
                    '10:00 AM',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ],
              ),

              // Check In Circle Button
              GestureDetector(onTap: (){
                router.push(routerCheckOutFirstPage);
              },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                      colors: [Color(0xFFDF99DB), Color(0xFFDD474A)],
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
                            'Check Out',
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
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
          child: Container(height: 35,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF69159), Color(0xFFF6685F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA5A5A5).withOpacity(0.5),

                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: const Center(
              child: Text(
                'Take a break',
                style: TextStyle(
                  color: Colors.white,fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

      ],
    ),
  );
}
