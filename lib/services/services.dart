import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:on_delivery/utils/file_utils.dart';
import 'package:on_delivery/utils/firebase.dart';

abstract class Service {
  Future<String?> uploadImage(Reference ref, File file) async {
    String? ext = FileUtils.getFileExtension(file);
    Reference storageReference = ref.child("${uuid.v4()}.$ext");
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    String? fileUrl = await storageReference.getDownloadURL();
    return fileUrl;
  }

  Future<String?> uploadV(Reference ref, File file) async {
    String? ext = FileUtils.getFileExtension(file);
    Reference storageReference = ref.child("${uuid.v4()}.$ext");

    UploadTask uploadTask = storageReference.putFile(
        file, firebase_storage.SettableMetadata(contentType: 'video/mp4'));
    await uploadTask.whenComplete(() => null);
    String? fileUrl = await storageReference.getDownloadURL();

    return fileUrl;
  }
}
