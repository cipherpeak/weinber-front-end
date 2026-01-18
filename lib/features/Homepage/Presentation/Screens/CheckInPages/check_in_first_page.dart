import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weinber/core/constants/constants.dart';
import '../../../../../core/constants/page_routes.dart';
import '../../../../../utils/Common Widgets/build_labelled_field.dart';
import '../../../Api/checkInOutRepo.dart';
import '../../Provider/checkInStatusNotifier.dart';

class CheckInFirstPage extends ConsumerStatefulWidget {
  const CheckInFirstPage({super.key});

  @override
  ConsumerState<CheckInFirstPage> createState() => _CheckInFirstPageState();
}

class _CheckInFirstPageState extends ConsumerState<CheckInFirstPage>
    with SingleTickerProviderStateMixin {
  String? _currentAddress = "Fetching location...";
  TimeOfDay selectedTime = TimeOfDay.now();

  late final AnimationController _controller;

  final int rippleCount = 3;
  final Duration rippleDuration = const Duration(seconds: 3);
  final double maxScale = 2;
  final List<Color> rippleColors = [
    const Color(0xFFFDDCE5),
    const Color(0xFFE1CEFB),
    const Color(0xFFF0C6FB),
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _controller = AnimationController(vsync: this, duration: rippleDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    await requestLocationPermission();
    await _getCurrentLocationAndAddress();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;
    if (status.isDenied || status.isRestricted) {
      await Permission.locationWhenInUse.request();
    }
  }

  Future<void> _getCurrentLocationAndAddress() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission permanently denied"),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
        setState(() {
          _currentAddress = address;
        });
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  void _onCheckInTap() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildConfirmDialog(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final centerButtonSize = width * 0.35;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 2.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Attendance Punch',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Location field
              buildLabelledField(
                label: "Location",
                required: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: _inputDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _currentAddress ?? "Fetching location...",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _getCurrentLocationAndAddress,
                        child: const Icon(Icons.location_on_outlined,
                            size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Time field
              buildLabelledField(
                label: "Time of Check In",
                required: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                  decoration: _inputDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime.format(context),
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const Icon(Icons.access_time_outlined,
                          size: 18, color: Colors.black54),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              /// Ripple button
              Center(
                child: SizedBox(
                  width: centerButtonSize * maxScale,
                  height: centerButtonSize * maxScale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = 0; i < rippleCount; i++)
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            final double offset = i / rippleCount;
                            double progress =
                                (_controller.value + offset) % 1.0;
                            final curved = Curves.easeOut.transform(progress);
                            final double scale =
                                0.5 + (curved * (maxScale - 0.5));
                            final double opacity =
                            (1.0 - curved).clamp(0.0, 1.0);
                            final ringSize = centerButtonSize * scale;

                            return SizedBox(
                              width: ringSize,
                              height: ringSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      (rippleColors[i % rippleColors.length])
                                          .withOpacity(opacity * 0.9),
                                      (rippleColors[i % rippleColors.length])
                                          .withOpacity(opacity * 0.55),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      /// Center circle
                      GestureDetector(
                        onTap: _onCheckInTap,
                        child: Container(
                          width: centerButtonSize,
                          height: centerButtonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment(-1, 1),
                              end: Alignment(-1, -1),
                              colors: [
                                Color(0xFFDBA2EA),
                                Color(0xFFF4B6DF),
                                Color(0xFFF6D1DC),
                              ],
                              stops: [0.0, 0.6, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Tap to",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Check In",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              /// Footer
              Container(
                height: 55,
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                margin: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text.rich(
                      TextSpan(
                        text: 'You have ',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black54),
                        children: [
                          TextSpan(
                            text: '4 tasks ',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: 'to complete today.'),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 15, color: Colors.black45),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirm Dialog
  Widget _buildConfirmDialog(BuildContext context) {
    final checkInNotifier = ref.read(checkInStatusProvider.notifier);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Confirm Check-In?",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your attendance will be marked for today. Make sure you’re at the work site before confirming.",
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildDialogDetails(),
            const SizedBox(height: 22),
            _buildDialogButtons(checkInNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _infoRow(Icons.location_on_outlined, _currentAddress ?? "Fetching location..."),
          const SizedBox(height: 20),
          _infoRow(Icons.access_time_outlined, selectedTime.format(context)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black45, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDialogButtons(checkInNotifier) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 35,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 3),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 35,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final now = DateTime.now();

                  final date = DateFormat('yyyy-MM-dd').format(now);
                  final time = DateFormat('HH:mm').format(now);
                  final timeZone = await FlutterNativeTimezone.getLocalTimezone();

                  // final repo = AttendanceRepository();

                  await AttendanceRepository.checkIn(
                    location: _currentAddress ?? "Unknown",
                    checkDate: date,
                    checkTime: time,
                    timeZone: timeZone,
                  );

                  // ✅ local attendance state
                  await checkInNotifier.setCheckInStatus(true);

                  if (!mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Checked in successfully"),
                    ),
                  );

                  router.go(routerHomePage);

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Check-in failed"),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 0,
                backgroundColor: primaryColor,
              ),
              child: const Text(
                "Confirm Check In",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
      color: Colors.white,
    );
  }
}
