import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  _ImageLoaderScreenState createState() => _ImageLoaderScreenState();
}

class _ImageLoaderScreenState extends State<SecondPage> {
  String? _imageFile;

  Future<bool> _requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> _pickImage() async {
    bool permissionGranted = await _requestPermission();

    if (permissionGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _imageFile = result.files.single.path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission denied!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Image from Local Storage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null) 
              Flexible(child: Image.file(
                File(_imageFile!),
                fit: BoxFit.contain,
                height: 300,
                ),
              )
            else 
              const Text('No image loaded.'),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Load Image'),
            ),
          ],
        ),
      ),
    );
  }
}