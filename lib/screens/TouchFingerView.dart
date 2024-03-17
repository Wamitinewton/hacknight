import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacknight_project/Data/constants.dart';
import 'package:hacknight_project/screens/Login_screen.dart';
import 'package:hacknight_project/screens/SignUpScreen.dart';
import 'package:hacknight_project/screens/custom_flat_button.dart';
import 'package:hacknight_project/widgets/navbar_roots.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class TouchFingerView extends StatefulWidget {
  const TouchFingerView({super.key});

  @override
  State<TouchFingerView> createState() => _TouchFingerViewState();
}

class _TouchFingerViewState extends State<TouchFingerView> {
  bool? _hasBioSensor;
  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      print(_hasBioSensor);
      if (_hasBioSensor != null && _hasBioSensor!) {
        _getAuth();
      } else {
        _navigateToManualLogin();
      }
    } on PlatformException catch (error) {
      EasyLoading.showToast("Failed! Please try again",
          toastPosition: EasyLoadingToastPosition.bottom,
          duration: Duration(seconds: 21),
          dismissOnTap: true,
          maskType: EasyLoadingMaskType.custom);
      EasyLoading.dismiss();
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
          localizedReason: 'Scan Your Fingerprint',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ));
      if (isAuth) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => NavBarRoots())));
        print(isAuth);
      }
    } on PlatformException catch (e) {
      EasyLoading.showToast("Failed! Please try again",
          toastPosition: EasyLoadingToastPosition.bottom,
          duration: Duration(seconds: 21),
          dismissOnTap: true,
          maskType: EasyLoadingMaskType.custom);
      EasyLoading.dismiss();
    }
  }

  void _navigateToManualLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: ((context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
           const Text(
              "Medical App",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            Text(
              'Quick login with Touch ID',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 17),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.fingerprint, size: 90, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Touch ID',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
            const Spacer(),
            CustomFlatButton(
                text: 'Login',
                color: MyColors.kPrimaryColor,
                textColor: Colors.white,
                onTap: () {
                  LoginScreen();
                }),
            const SizedBox(height: 20),
            CustomFlatButton(
                text: 'Register',
                color: Colors.white,
                textColor: MyColors.kPrimaryColor,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                }),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
