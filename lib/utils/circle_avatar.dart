import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/repository/profile_data.dart';
import 'package:hacknight_project/services/storage/profile_service.dart';

import '../services/storage/avatar_controller.dart';
import 'profile_dialog.dart';

class ProfileAvatar extends StatelessWidget {
  final AvatarController _avatarController = Get.put(
      AvatarController(ImagePickerRepositoryImpl(), ProfileStorageService()));
  ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    _avatarController.loadProfilePhoto(FirebaseAuth.instance.currentUser!.uid);
    return Stack(
      children: [
        Obx(() {
          return _avatarController.imagePath.value.isNotEmpty
              ? CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      FileImage(File(_avatarController.imagePath.toString())),
                )
              : const CircleAvatar(
                  radius: 64,
                  backgroundImage: AssetImage("assets/user.png"),
                );
        }),
        Positioned(
            bottom: -10,
            left: 80,
            child: IconButton(
              onPressed: _avatarController.pickImage,
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.black,
              ),
            ))
      ],
    );
  }
  // await showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('Profile options'),
  //               content: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         _avatarController.pickImage();
  //                       },
  //                       child: const Text('Change profile')),
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         ProfileDialogUtil.showProfilePictureDialog(
  //                             _avatarController);
  //                         Get.back();
  //                       },
  //                       child: const Text('View profile'))
  //                 ],
  //               ),
  //             );
  //           });
}
