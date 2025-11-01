import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';
import '../../../../../utils/Common Widgets/build_labelled_field.dart';
import '../../Provider/checkInStatusNotifier.dart';

class CheckOutFirstPage extends ConsumerStatefulWidget {
  const CheckOutFirstPage({super.key});

  @override
  ConsumerState<CheckOutFirstPage> createState() => _CheckOutFirstPageState();
}

class _CheckOutFirstPageState extends ConsumerState<CheckOutFirstPage>
    with SingleTickerProviderStateMixin {
  String? _currentAddress = "Fetching location...";
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedReason;

  final List<String> Reasons = [
    'Break',
    'Shift Ended',
    'Emergency',
    'Leave',
  ];

  late final AnimationController _controller;

  // ripple customization
  final int rippleCount = 3;
  final Duration rippleDuration = const Duration(seconds: 3);
  final double maxScale = 2; // how large the ripples grow relative to center
  final List<Color> rippleColors = [
    const Color(0xFFFDDCE5),
    const Color(0xFFE1CEFB),
    const Color(0xFFF0C6FB),
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();

    _controller = AnimationController(
      vsync: this,
      duration: rippleDuration,
    )..repeat();
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

  void _onCheckOutTap() {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Location field
              buildLabelledField(
                label: "Location",
                required: true,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: _inputDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _currentAddress ?? "Fetching location...",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _getCurrentLocationAndAddress,
                        child: const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Time field
              buildLabelledField(
                label: "Time of Check Out",
                required: true,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: _inputDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime.format(context),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const Icon(
                        Icons.access_time_outlined,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// Reason field
              buildLabelledField(
                label: "Reason for Check Out",
                required: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: _inputDecoration(),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: selectedReason),
                          onChanged: (value) => selectedReason = value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Select or enter Reason",
                            hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.grey),
                        onSelected: (String value) {
                          setState(() {
                            selectedReason = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return Reasons.map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Ripple Check-Out area
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

                      /// Center Circle Button
                      GestureDetector(
                        onTap: _onCheckOutTap,
                        child: Container(
                          width: centerButtonSize,
                          height: centerButtonSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment(-1, 1),
                              end: Alignment(-1, -1),
                              colors: [
                                Color(0xFFF3494E),
                                Color(0xFFE896D7),
                                Color(0xFFE69CE2),
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
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Check Out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
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

              /// Bottom Footer
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
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: '1 tasks ',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: 'to complete today.'),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Confirm Check-Out Dialog
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Confirm Check-Out?",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your attendance will be marked for today. Make sure you’re at the work site before confirming.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
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
          const SizedBox(height: 20),
          _infoRow(Icons.note_alt_outlined, selectedReason ?? "Select Reason"),
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
            style: const TextStyle(fontSize: 12, color: Colors.black54),
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
                  fontSize: 12,
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
                if (selectedReason == null || selectedReason!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text("Please select or enter a reason for check-out"),
                    ),
                  );
                  return;
                }

                await checkInNotifier.setCheckInStatus(false);

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "Checked Out Successfully!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                  router.go(routerHomePage);
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
                "Confirm Check Out",
                style: TextStyle(
                  fontSize: 12,
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
