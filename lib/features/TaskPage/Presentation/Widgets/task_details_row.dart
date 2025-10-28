import 'package:flutter/material.dart';

Widget buildDetailRow(String title, String value, {required final myWidth, bool bold = false} ) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            SizedBox(
              width: myWidth * 0.4,
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                value,
                maxLines: 3,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        )
        ,
      ),

      Divider(thickness: .5,),
      SizedBox(height: 8,)
    ],
  );
}