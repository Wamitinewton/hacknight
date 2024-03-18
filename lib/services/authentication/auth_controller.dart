import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hacknight_project/Models/user_credentials.dart';
import 'package:hacknight_project/screens/Home_Screen.dart';
import 'package:hacknight_project/screens/Login_screen.dart';

class AuthController extends GetxController {
  // bloc
  // provider
  final TextEditingController name = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController cfmpwd = TextEditingController();
  // clean model architecture

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _gAuth = GoogleSignIn();


  RxString username = ''.obs;
  RxBool isLoading = false.obs;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

// explain on these.
  void setUsername(String value) {
    username.value = value;
  }

  Future<void> signUp(String email, String username, String password,
      String confirmpassword) async {
    isLoading.value = true;
    try {
      EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        status: "Authenticating....",
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
      isLoading.value = false;

      EasyLoading.addStatusCallback((_) {
        EasyLoading.show(
          indicator: const Icon(Icons.check),
          status: "Authenticated",
          dismissOnTap: true,
        );
      });
      Future.delayed(const Duration(seconds: 2));
      Get.to(HomeScreen());
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message!);
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
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
     
      isLoading.value = false;

      Future.delayed(const Duration(seconds: 2), () {
        
        Get.offAll(HomeScreen(
          
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
 Future<User?> signInWithGoogle() async {
  
  try {
    isLoading.value = true;
    final GoogleSignInAccount? googleSignInAccount = await _gAuth.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      Get.offAll(HomeScreen());
      return user;
      
    }
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally{
    isLoading.value = false;
  }
  return null;
 }


  Future<void> logOut() async {
    try {
      await _auth.signOut();
      await _gAuth.signOut();
    user.value = null;
    Get.offAll(LoginScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
