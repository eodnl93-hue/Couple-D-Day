import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ImageProvider getImageProvider(String path) {
  if (path.startsWith('http') || path.startsWith('blob:')) {
    return NetworkImage(path);
  }
  if (kIsWeb) {
    return NetworkImage(path);
  } else {
    return FileImage(File(path));
  }
}

Widget buildImageWidget(String path, {BoxFit fit = BoxFit.cover}) {
  if (path.startsWith('http') || path.startsWith('blob:')) {
    return Image.network(path, fit: fit);
  }
  if (kIsWeb) {
    return Image.network(path, fit: fit);
  } else {
    return Image.file(File(path), fit: fit);
  }
}
