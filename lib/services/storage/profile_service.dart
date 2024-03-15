import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfilePhoto(File file, String userId) async {
    try {
      final Reference storageRef =
          _storage.ref().child('profile_photos/$userId.jpg');

      await storageRef.putFile(file);
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error uploading profile', backgroundColor: Colors.redAccent);
      return null;
    }
  }

  Future<String?> getProfilePhotoUrl(String userId) async {
    try {
      final Reference storageRef =
          _storage.ref().child('profile_photos/$userId.jpg');
      return await storageRef.getDownloadURL();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error fetching your profile',
          backgroundColor: Colors.redAccent);
    }
    return null;
  }
}
