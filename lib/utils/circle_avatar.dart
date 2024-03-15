
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
    _avatarController.loadProfilePhoto('wbK4jQMtrGWLld66NQmEe5vpbMq2');
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Profile options'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _avatarController.pickImage();
                        },
                        child: const Text('Change profile')),
                    ElevatedButton(
                        onPressed: () {
                          ProfileDialogUtil.showProfilePictureDialog(
                              _avatarController);
                          Get.back();
                        },
                        child: const Text('View profile'))
                  ],
                ),
              );
            });
      },
      child: Obx(() => CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: ClipOval(
            child: Align(
              alignment: Alignment.center,
              child: _avatarController.imagePath.value.isNotEmpty
                  ? Image.network(
                      _avatarController.imagePath.value,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.white,
                    ),
            ),
          ))),
    );
  }
}
