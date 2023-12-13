import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
/*
allows users to select an image from either the camera or the photo gallery
The selected image is displayed and saved in firebase
 */
class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({super.key, this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;
//open the camera or gallery, allowing the user to pick an image.
// The selected image file is stored in the _image state.
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_image!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
        if (_image != null) ...[
          const SizedBox(height: 8),
          //The selected image is displayed using the Image.file widget
          Image.file(
            _image!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (widget.onImageSelected != null) {
                widget.onImageSelected!(_image!);
              }
            },
            child: const Text('Upload to Firebase'),
          ),
        ],
      ],
    );
  }
}