import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({this.onImageSelected});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

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
        Text(
          'Select Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
        if (_image != null) ...[
          SizedBox(height: 8),
          Image.file(
            _image!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (widget.onImageSelected != null) {
                widget.onImageSelected!(_image!);
              }
            },
            child: Text('Upload to Firebase'),
          ),
        ],
      ],
    );
  }
}