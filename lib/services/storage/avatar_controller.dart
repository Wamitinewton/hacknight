import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/repository/image_repo.dart';
import 'package:hacknight_project/services/storage/profile_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AvatarController extends GetxController {
  final ImagePickerRepository _imagePickerRepository;
  final ProfileStorageService _storageService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AvatarController(this._imagePickerRepository, this._storageService);

  final RxString imagePath = ''.obs;
  final String imagePathKey = 'profile_image_path';
  // final RxString imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // String uid = Get.find<AuthController>().
    loadSavedImagePath();
  }

  Future<void> pickImage() async {
    final String? pickedImagePath = await _imagePickerRepository.pickImage();
    if (pickedImagePath != null) {
      imagePath.value = pickedImagePath;
      await _storageService.uploadProfilePhoto(
          File(pickedImagePath), FirebaseAuth.instance.currentUser!.uid);

      await loadProfilePhoto(FirebaseAuth.instance.currentUser!.uid);
      saveImageToPrefs(pickedImagePath);
    }
  }

  Future<void> loadProfilePhoto(String userId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final String? photoUrl = await _storageService.getProfilePhotoUrl(userId);
    if (photoUrl != null) {
      imagePath.value = photoUrl;

      File imageFile = File(photoUrl);

      if (await imageFile.exists()) {}
    }
  }

  Future<void> saveImageToPrefs(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(imagePathKey, path);
  }

  Future<void> loadSavedImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath = prefs.getString(imagePathKey);
    if (savedPath != null && savedPath.isNotEmpty) {
      imagePath.value = savedPath;
    }
  }
}
