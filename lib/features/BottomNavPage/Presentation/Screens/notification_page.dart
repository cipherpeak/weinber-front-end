import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/page_routes.dart';
import '../../../Authentication/Login/Model/hive_login_model.dart';
import '../Provider/bottom_nav_provider.dart';
import 'meeting_list.dart';
import 'notification_list.dart';


class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  var company;
  var employeeType;
  var taskRoutePage = '';

  // Map index -> route path inside the shell
  late final List<String> _tabRoutes = [
    '/app/home',
    taskRoutePage,
    '/app/attendance',
    '/app/report',
  ];


  late AuthLocalStorage _local;

  @override
  void initState() {
    super.initState();
    initializeFunctions();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> initializeFunctions() async {

    _local = AuthLocalStorage.instance;
    await _local.init();
    company = _local.getCompany();
    employeeType = _local.getEmployeeType();
    setState(() {
      taskRoutePage = _getTaskRoute(employeeType, company);
    });
  }

  String _getTaskRoute(String? employeeType, String? company) {
    final type = employeeType?.toLowerCase().trim();
    final comp = company?.toLowerCase().trim();

    // 🔧SERVICE LOGIC (company-based)
    if (type == "service") {
      if (comp == "dax") {
        return routerDaxTaskPage;
      } else if (comp == "advantage") {
        return routerAdvantageTaskPage;
      } else {
        // any other company but service employee
        return routerDaxTaskPage;
      }
    }

    //  DELIVERY (same for all companies)
    if (type == "deliver") {
      return routerDeliveryTaskPage;
    }

    //  OFFICE
    if (type == "office") {
      return routerNotesPage;
    }

    //  MECHANIC
    if (type == "mechanic") {
      return routerTechnicianTaskPage;
    }

    //  fallback safety
    return routerAdvantageTaskPage;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => router.go(_tabRoutes[currentIndex]),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: appFont,
            color: Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          indicatorWeight: 3,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "General Updates"),
            Tab(text: "Meeting Updates"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GeneralNotificationList(),
          MeetingNotificationList(), // 🔥 API goes here later
        ],
      ),
    );
  }
}
