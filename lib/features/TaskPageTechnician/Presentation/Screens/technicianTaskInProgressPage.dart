import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/core/constants/constants.dart';
import 'package:weinber/core/constants/page_routes.dart';
import 'package:weinber/features/Homepage/Presentation/Provider/home_notifier.dart';

import '../../../../utils/Common Functions/compressImage.dart';
import '../../../BottomNavPage/Presentation/Provider/bottom_nav_provider.dart';
import '../../Api/technician_task_repo.dart';
import '../../Model/technician_start_details_model.dart';

class TechnicianTaskInProgressScreen extends ConsumerStatefulWidget {
  final int taskId;

  const TechnicianTaskInProgressScreen({
    super.key,
    required this.taskId,
  });

  @override
  ConsumerState<TechnicianTaskInProgressScreen> createState() =>
      _TechnicianTaskInProgressScreenState();
}

class _TechnicianTaskInProgressScreenState
    extends ConsumerState<TechnicianTaskInProgressScreen> {

  final repo = TechnicianTaskRepository();

  bool loading = true;
  bool endingTask = false;
  String? error;
  TechnicianTaskStartDetails? data;

  final progressController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    _loadStartedTask();
  }

  Future<void> _loadStartedTask() async {
    try {
      final res = await repo.fetchStartedTaskDetails(widget.taskId);

      if (!mounted) return;

      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  // ================= IMAGE PICK =================

  Future<void> _pickFromCamera() async {
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (picked != null) {
      setState(() {
        selectedImages.add(File(picked.path));
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final pickedList = await picker.pickMultiImage(imageQuality: 70);

    if (pickedList.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedList.map((e) => File(e.path)));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  // ================= END TASK =================

  Future<void> _endTask() async {
    if (endingTask) return;

    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please add at least one completion image"),
        ),
      );
      return;
    }

    setState(() => endingTask = true);

    try {
      // API supports only single image → send first one
      final compressed = await compressImage(selectedImages.first);

      await repo.endTechnicianTask(
        taskId: widget.taskId,
        notes: progressController.text,
        image: compressed,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Task completed successfully"),
        ),
      );

      ref.read(homeNotifierProvider.notifier).refresh();
      router.go(routerHomePage);
      ref.read(bottomNavProvider.notifier).changeIndex(0);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) setState(() => endingTask = false);
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    }

    final t = data!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskInfoCard(t),
            const SizedBox(height: 24),
            _progressInput(),

            if (selectedImages.isNotEmpty) ...[
              const SizedBox(height: 14),
              _imagePreviewGrid(),
            ],
          ],
        ),
      ),


      bottomNavigationBar: t.status.toLowerCase() == "completed"
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: endingTask ? null : _endTask,
            child: endingTask
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              "End Task",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

    );
  }

  // ================= IMAGE GRID =================

  Widget _imagePreviewGrid() {
    return GridView.builder(
      itemCount: selectedImages.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedImages[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ================= BOTTOM SHEET =================

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= TASK INFO CARD =================

  Widget _taskInfoCard(TechnicianTaskStartDetails t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("#${t.taskId}",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              _statusChip(t.status),
            ],
          ),
          const SizedBox(height: 6),
          Text(t.machineInfo,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text("Bay: ${t.bayNumber}",
                  style: const TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Text("Started at: ${t.startedAt.substring(0, 8)}",
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFF9800),
        ),
      ),
    );
  }

  // ================= PROGRESS INPUT =================

  Widget _progressInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: progressController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Add progress notes here",
                hintStyle: TextStyle(fontSize: 13, color: Colors.black38),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        GestureDetector(
          onTap: _showImageSourcePicker,
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
