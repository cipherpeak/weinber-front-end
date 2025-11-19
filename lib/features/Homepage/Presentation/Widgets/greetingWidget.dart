import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget GreetingWidget({required  String name})  {
   return Column(
  children: [
    Text(
      'Hello $name 👋',
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 6),
    const Text(
      'Welcome back to your workspace.',
      style: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    const SizedBox(height: 15),
  ],
);
}