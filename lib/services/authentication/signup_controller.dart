import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/Models/user_credentials.dart';
import 'package:hacknight_project/screens/Home_Screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController cfmpwd = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  RxString username = ''.obs;
  RxBool isLoading = false.obs;

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  void setUsername(String value) {
    username.value = value;
  }

  Future<void> signUp(String email, String username, String password,
      String confirmPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.value!.uid);
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.custom,
        status: "Authenticating...",
        dismissOnTap: false,
      );

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel user = UserModel(
          name: name.text,
          email: mail.text,
          id: result.user!.uid,
          password: pwd.text);

      await _db.collection("users").doc(result.user!.uid).set(user.toJson());
      EasyLoading.dismiss();

      EasyLoading.addStatusCallback((_) {
        EasyLoading.show(
          indicator: const Icon(
            Icons.check,
            color: Colors.blue,
          ),
          status: "Authenticated",
          dismissOnTap: true,
        );
      });

      Future.delayed(const Duration(seconds: 1));
      // EasyLoading.dismiss();
      Get.offAll(HomeScreen(
        userName: user.name!,
      ));
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message!);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        status: "Authenticating...",
        dismissOnTap: false,
      );

      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user.value = result.user;
      // UserModel user = UserModel(
      //   name: name.text,
      //   email: mail.text,
      //   id: result.user!.uid,
      //   password: pwd.text
      // );

      Future.delayed(const Duration(seconds: 2), () {
        // EasyLoading.dismiss();
        Get.offAll(HomeScreen(
          userName: user.value!.displayName ?? "",
        ));
      });

      EasyLoading.addStatusCallback((status) {
        EasyLoading.show(
          indicator: const Icon(
            Icons.check,
            color: Colors.blue,
          ),
          status: "Authenticated",
          dismissOnTap: true,
        );
      });
      EasyLoading.dismiss();
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message!);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
    user.value = null;
  }
}
