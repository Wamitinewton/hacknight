import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacknight_project/screens/SignUpScreen.dart';
import 'package:local_auth/local_auth.dart';

import '../Data/constants.dart';
import '../services/authentication/auth_controller.dart';
import '../widgets/navbar_roots.dart';
import 'bezier_card.dart';
import 'custom_buttons.dart';
import 'custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<LoginScreen> {
  final TextEditingController mail = TextEditingController();
  final TextEditingController pwd= TextEditingController();
  // final _passwordController = TextEditingController();
  // // final _conformpasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _controller = Get.find<AuthController>();
  bool? _hasBioSensor;

  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      if (_hasBioSensor!) {
        _getAuth();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuth = false;
    try {
      isAuth = await authentication.authenticate(
          localizedReason: 'Scan your fingerprint',
          options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true));
      if (isAuth) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NavBarRoots()));
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height* .2),
                    const Text(
                      "Medical App",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      "Email",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextField(
                      isPassword: false,
                      controller: mail,
                      hintText: 'Email Address',
                      validator: (value) {
                        if (!value!.isEmail) {
                          return 'Please enter valid email address';
                        } else if (value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Text(
                    //   "Full Name",
                    //   style: GoogleFonts.poppins(
                    //       color: Colors.black,
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w400),
                    // ),
                    // CustomTextField(
                    //   isPassword: false,
                    //   controller: _fullNameController,
                    //   hintText: 'Full Name',
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter your full name';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    Text(
                      "Password",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextField(
                      isPassword: true,
                      controller: pwd,
                      hintText: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Your Password length must be greater than 6';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                   
                    const SizedBox(height: 20),
                    PrimaryButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await _controller.signIn(mail.text, pwd.text);
                        }
                      },
                      text: "Register",
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offAll(SignUpScreen());
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  color: MyColors.kPrimaryColor, fontSize: 14),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
