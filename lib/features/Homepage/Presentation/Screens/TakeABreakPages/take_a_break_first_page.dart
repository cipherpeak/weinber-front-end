import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';
import '../../../Api/takeABreakRepo.dart';
import '../../../Database/breakTimerHive.dart';

class TakeABreakFirstPage extends StatefulWidget {
  const TakeABreakFirstPage({super.key});

  @override
  State<TakeABreakFirstPage> createState() => _TakeABreakFirstPageState();
}

class _TakeABreakFirstPageState extends State<TakeABreakFirstPage> {
  String selectedBreak = '';
  int selectedDuration = 10;
  final TextEditingController otherController = TextEditingController();
  bool isLoading = false;

  final List<int> durations = [10, 15, 20];

  final List<Map<String, dynamic>> breakTypes = [
    {'title': 'Lunch Break', 'icon': Icons.lunch_dining, 'api': 'lunch'},
    {'title': 'Coffee Break', 'icon': Icons.local_cafe, 'api': 'coffee'},
    {'title': 'Stretch Break', 'icon': Icons.self_improvement, 'api': 'stretch'},
  ];

  String _mapBreakTypeToApi(String value) {
    final match = breakTypes.where((e) => e['title'] == value);
    if (match.isNotEmpty) return match.first['api'];
    return "other";
  }

  Future<void> _startBreak() async {
    if (selectedBreak.isEmpty) return;

    try {
      setState(() => isLoading = true);

      final now = DateTime.now();
      final apiBreakType = _mapBreakTypeToApi(selectedBreak);

      await BreakRepository().startBreak(
        breakType: apiBreakType,       // lunch / coffee / stretch / other
        date: DateFormat('yyyy-MM-dd').format(now),
        time: DateFormat('HH:mm:ss').format(now),
        location: "UAE",
        duration: selectedDuration,
        customType: apiBreakType == "other" ? otherController.text.trim() : null,
      );

      await BreakLocalStorage.saveBreak(
        breakType: selectedBreak,
        startTime: now.toUtc(),
        allowedMinutes: selectedDuration,
      );

      if (!mounted) return;

      router.go(routerHomePage);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Break started successfully"),
        ),
      );
    } catch (e, st) {
      debugPrint("❌ START BREAK ERROR: $e");
      debugPrint("🧵 $st");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to start break: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose Your Break Type",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => router.go(routerHomePage),
        ),
      ),
      backgroundColor: primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...breakTypes.map((b) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBreak = b['title'];
                    otherController.clear();
                  });
                },
                child: _breakTile(b),
              )),

              const SizedBox(height: 10),
              const Text("Others", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),

              TextField(
                controller: otherController,
                onChanged: (v) {
                  setState(() {
                    if (v.trim().isNotEmpty) selectedBreak = v.trim();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Enter break type",
                  filled: true,
                ),
              ),

              const SizedBox(height: 20),
              const Text("Duration", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              Row(
                children: durations.map((d) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedDuration = d),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selectedDuration == d
                              ? Colors.blue.shade100
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: Text("$d min"),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: screenHeight * 0.18),
            ],
          ),
        ),
      ),

      /// ▶ START BREAK BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _startBreak,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Text(
              "Start Break",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  Widget _breakTile(Map<String, dynamic> b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selectedBreak == b['title']
            ? Colors.blue.shade50
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(b['icon']),
          const SizedBox(width: 12),
          Text(
            b['title'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
