import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

class PickedImagesNotifier extends StateNotifier<List<XFile>> {
  PickedImagesNotifier() : super([]);

  void addImages(List<XFile> images) {
    state = [...state, ...images];
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.length) {
      state = List.from(state)..removeAt(index);
    }
  }

  void clearImages() {
    state = [];
  }
}