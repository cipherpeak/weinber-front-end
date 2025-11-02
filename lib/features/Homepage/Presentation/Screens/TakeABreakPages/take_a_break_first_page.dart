import 'package:flutter/material.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';

class TakeABreakFirstPage extends StatefulWidget {
  const TakeABreakFirstPage({super.key});

  @override
  State<TakeABreakFirstPage> createState() => _TakeABreakFirstPageState();
}

class _TakeABreakFirstPageState extends State<TakeABreakFirstPage> {
  String selectedBreak = '';
  int selectedDuration = 10;
  final TextEditingController otherController = TextEditingController();
  final List<int> durations = [10, 15, 20];

  final List<Map<String, dynamic>> breakTypes = [
    {
      'title': 'Lunch Break',
      'icon': Icons.lunch_dining,
      'color': Colors.blue.shade100,
    },
    {
      'title': 'Coffee Break',
      'icon': Icons.local_cafe,
      'color': Colors.yellow.shade100,
    },
    {
      'title': 'Stretch Break',
      'icon': Icons.self_improvement,
      'color': Colors.purple.shade100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Choose Your Break Type",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => router.go(routerHomePage),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: primaryBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ...breakTypes.map(
                    (b) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedBreak = b['title'];
                      otherController.clear();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedBreak == b['title']
                          ? b['color'].withOpacity(0.4)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedBreak == b['title']
                            ? Colors.blueAccent
                            : Colors.grey.shade200,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: b['color'],
                          child: Icon(
                            b['icon'],
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          b['title'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Others",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: otherController,
                  onChanged: (value) {
                    setState(() {
                      selectedBreak = value.isNotEmpty ? value : selectedBreak;
                    });
                  },
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: "Enter break type",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Duration",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: durations.map((d) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDuration = d;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selectedDuration == d
                              ? Colors.blue.shade100
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedDuration == d
                                ? Colors.blueAccent
                                : Colors.grey.shade200,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$d min",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: selectedDuration == d
                                ? Colors.blueAccent
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontSize: 13),
                    hintText: "Custom minutes",
                    suffixStyle: const TextStyle(fontSize: 13),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: List.generate(
                    60,
                        (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1} min",
                          style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedDuration = value;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.12),
            ],
          ),
        ),
      ),

      // 🔹 Floating Start Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedBreak.isEmpty
                ? null
                : () {
              router.go(routerHomePage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.green,
                  content: Text(
                    'Starting $selectedBreak for $selectedDuration min!',
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 6,
              shadowColor: primaryColor.withOpacity(0.3),
            ),
            child: const Text(
              "Start Break",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
