import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/storage/avatar_controller.dart';

class ProfileDialogUtil {
  static void showProfilePictureDialog(AvatarController avatarController) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile Picture'),
            content: Obx(() => SizedBox(
                  height: 160,
                  width: 160,
                  child: avatarController.imagePath.value.isNotEmpty
                      ? Image.network(
                          avatarController.imagePath.value,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 140,
                          color: Colors.white,
                        ),
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}
