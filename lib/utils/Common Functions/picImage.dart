import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImage(BuildContext context) async {
  final picker = ImagePicker();
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Photo'),
            onTap: () async {
              await picker.pickImage(source: ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              await picker.pickImage(source: ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}
