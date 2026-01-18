import 'package:flutter/material.dart';
import 'package:weinber/core/constants/page_routes.dart';

import '../../../../utils/Common Functions/format_date_time.dart';
import '../../Model/homepage_response.dart';
import 'attendace_card_check_in.dart';

Widget attendanceCardCheckOut(CheckInOut data) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey.shade200, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.06),
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
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
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Check-in / Check-out times
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              timeInfo("Checked In at:", formatApiTime(data.checkIn.time)),
              GestureDetector(
                onTap: () {
                  router.push(routerCheckOutFirstPage);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Gradient Outer Ring
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFDE97D9),
                            Color(0xFFE8474A),
                          ],
                          stops: [0.0, 1.0],
                        ),
                      ),
                    ),

                    // White Inner Circle
                    Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Check Out',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.black54,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              timeInfo("Checked Out at:", formatApiTime(data.checkOut.time)),
            ],
          ),
        ),
        GestureDetector(onTap: (){
          router.go(routerTakeBreakPage);
        },
          child: Padding(
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
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: const Center(
                child: Text(
                  'Take a break',
                  style: TextStyle(
                    color: Colors.white,fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
