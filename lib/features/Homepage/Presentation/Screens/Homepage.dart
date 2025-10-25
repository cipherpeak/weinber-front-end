import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomepageScreen extends ConsumerStatefulWidget {
  const HomepageScreen({super.key});

  @override
  ConsumerState<HomepageScreen> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<HomepageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Homepage'),),);
  }
}
