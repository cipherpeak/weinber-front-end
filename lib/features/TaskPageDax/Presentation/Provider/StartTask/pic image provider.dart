// Provider for managing the list of picked images
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weinber/features/TaskPageDax/Presentation/Provider/StartTask/pick%20image%20notifier.dart';

final pickedImagesProvider = StateNotifierProvider<PickedImagesNotifier, List<XFile>>((ref) {
  return PickedImagesNotifier();
});