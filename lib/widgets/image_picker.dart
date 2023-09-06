import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

class ImagePicker extends StatefulWidget {
  const ImagePicker(this.onImagePicked, {super.key});

  final void Function(File pickedImage) onImagePicked;

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  File? pickedImageFile;
  void _pickImage() async {
    final img_picker.XFile? imageFile =
        await img_picker.ImagePicker().pickImage(
      source: img_picker.ImageSource.camera,
      imageQuality: 50,
      maxHeight: 200,
      maxWidth: 200,
    );

    if (imageFile == null) {
      return;
    }
    setState(() {
      pickedImageFile = File(imageFile.path);
    });
    widget.onImagePicked(pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              pickedImageFile != null ? FileImage(pickedImageFile!) : null,
        ),
        // const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Take a picture'),
        ),
      ],
    );
  }
}
