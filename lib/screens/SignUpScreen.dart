import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacknight_project/screens/Login_screen.dart';
import 'package:hacknight_project/services/authentication/auth_controller.dart';
import 'package:hacknight_project/utils/auth_option.dart';
import 'package:local_auth/local_auth.dart';


import '../Data/constants.dart';
import '../widgets/navbar_roots.dart';
import 'bezier_card.dart';
import 'custom_buttons.dart';
import 'custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _controller = Get.find<AuthController>();
  static final TextEditingController mail = TextEditingController();
  static final TextEditingController name = TextEditingController();
  static final TextEditingController pwd = TextEditingController();
  static final TextEditingController cfmpwd = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true));
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
                    SizedBox(height: MediaQuery.of(context).size.height * .2),
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
                      keyboardType: TextInputType.emailAddress,
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
                    Text(
                      "Full Name",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      isPassword: false,
                      controller: name,
                      hintText: 'Full Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Password",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.multiline,
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
                    Text(
                      "Confrrm Password",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.multiline,
                      isPassword: true,
                      controller: cfmpwd,
                      hintText: 'Conform Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter confirm password';
                        } else if (value.length < 6) {
                          return 'Your Password length must be greater than 6';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (pwd.text == cfmpwd.text) {
                            await _controller.signUp(
                                mail.text, name.text, pwd.text, cfmpwd.text);
                          } else {
                            Fluttertoast.showToast(
                                msg: "Password's doesn't match",
                                backgroundColor: Colors.redAccent);
                          }
                        }
                      },
                      text: "Register",
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        TextButton(
                            onPressed: () {
                              LoginScreen();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: MyColors.kPrimaryColor, fontSize: 14),
                            ))
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: AuthMethods(text: 'Google Authentication', authlogo: 'authlogo1',
                      onTap: () {
                        _controller.signInWithGoogle();
                      },
                       ),
                    )
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
