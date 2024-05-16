import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String? imagePath;
  const ImageWidget({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imagePath != null
            ? Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              )
            : Image.asset('assets/images/no_image.jpg'));
  }
}
