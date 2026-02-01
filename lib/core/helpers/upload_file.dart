import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageUploader {
  final FirebaseStorage storage;
  StorageUploader(this.storage);

  Future<String> uploadImageXFile({
    required XFile file,
    required String path, // مثال: projects/{id}/cover/cover.png
  }) async {
    final ref = storage.ref().child(path);

    final metadata = SettableMetadata(
      contentType: _guessContentType(file.name),
      cacheControl: 'public,max-age=31536000',
    );

    UploadTask task;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      task = ref.putData(bytes, metadata);
    } else {
      task = ref.putFile(File(file.path), metadata);
    }

    await task;
    return await ref.getDownloadURL();
  }

  String _guessContentType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'application/octet-stream';
  }
}
