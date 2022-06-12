// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:backup_your_phone/provider/get_user.dart';
import 'package:backup_your_phone/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadImagesToFB(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('images/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (err) {
      ToastMassageShort(msg: err.toString());
    }
  }

  // Future<void> uploadFoldersToFB(String folderePath, String folderName) async {
  //   File file = File(filePath);
  //   try {
  //     await storage.ref('${user!.uid}/images/$fileName').putFile(file);
  //   } on firebase_core.FirebaseException catch (err) {
  //     ToastMassageShort(msg: err.toString());
  //   }
  // }

  Future<firebase_storage.ListResult> listImages() async {
    firebase_storage.ListResult result = await storage.ref('images').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file $ref');
    });
    return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('${user!.uid}/images/$imageName').getDownloadURL();
    return downloadUrl;
  }
}
