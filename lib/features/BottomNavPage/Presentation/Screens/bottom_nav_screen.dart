import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weinber/core/constants/constants.dart';

import '../../../../core/constants/page_routes.dart';
import '../../../AttendancePage/Presentation/Screens/AttendancePage.dart';
import '../../../Homepage/Presentation/Screens/Homepage.dart';
import '../../../ReportPage/Presentation/Screens/ReportPage.dart';
import '../../../TaskPage/Presentation/Screens/TaskScreen.dart';
import '../Provider/bottom_nav_provider.dart';

class BottomNavScreen extends ConsumerStatefulWidget {
  final Widget child; // <-- required by ShellRoute

  const BottomNavScreen({super.key, required this.child});

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Map index -> route path inside the shell
  static const List<String> _tabRoutes = [
    '/app/home',   // index 0
    '/app/task',   // index 1
    '/app/attendance', // index 2 (if you add route)
    '/app/report', // index 3 (if you add route)
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onTap(int index) {
    // Update Riverpod state
    ref.read(bottomNavProvider.notifier).changeIndex(index);

    // Use GoRouter to switch the shell child route so URL + navigator are in sync.
    // Guard against out-of-range routes:
    if (index >= 0 && index < _tabRoutes.length) {
      // Use context.go to switch the nested route under ShellRoute
      router.go(_tabRoutes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Image.asset(
                'assets/logos/logo.png',
                height: 35,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                color: Colors.black87,
              ),
              const SizedBox(width: 8),
              GestureDetector(onTap: (){
                router.push(routerProfilePage);
              },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: const AssetImage('assets/images/profile.png'),
                ),
              ),
            ],
          ),
        ),

        // Use the child provided by ShellRoute as the body (this is the key change)
        body: widget.child,

        bottomNavigationBar: _FloatingBottomNavBar(
          currentIndex: currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}

class _FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _FloatingBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      Icons.home_outlined,
      Icons.task_alt_outlined,
      Icons.access_time,
      Icons.bar_chart_outlined,
    ];
    final labels = ['Home', 'Tasks', 'Attendance', 'Report'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(items.length, (index) {
            final isSelected = currentIndex == index;
            final lift = isSelected ? -18.0 : 0.0;

            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: Offset(0, lift),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(1),
                        height: isSelected ? 50 : 45,
                        width: isSelected ? 50 : 44,
                        decoration: BoxDecoration(
                          color:
                          isSelected ? primaryColor : Colors.transparent,
                          shape: BoxShape.circle,
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ]
                              : [],
                        ),
                        child: Icon(
                          items[index],
                          color:
                          isSelected ? Colors.white : Colors.grey.shade500,
                          size: isSelected ? 32 : 30,
                        ),
                      ),
                    ),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? primaryColor : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
