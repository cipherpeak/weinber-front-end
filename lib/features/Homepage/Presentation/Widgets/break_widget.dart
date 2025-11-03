import 'package:flutter/material.dart';

class BreakHistoryCard extends StatelessWidget {
  final String totalBreakTime;
  final int extendedBreaks;

  const BreakHistoryCard({super.key,
    this.totalBreakTime = '0h 28m',
    this.extendedBreaks = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Break History",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text('See all', style: TextStyle(fontSize: 13, color: Colors.grey),),
                    Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
                  ],
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            color: Color(0xFFFBF6F2),elevation: .5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalBreakTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFEA9662),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Total break time',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        extendedBreaks.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Extended breaks',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
