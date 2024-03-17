import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/bindings/controller_bindings.dart';
import 'package:hacknight_project/screens/Home_Screen.dart';
import 'package:hacknight_project/screens/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAF7QdK4jABYetr3Yg_11pOYkiwGIjHADc",
    appId: "1:319675423162:android:0f84fcc763fb371a4ba583",
    messagingSenderId: "319675423162",
    projectId: "hacknight-de5df",
    storageBucket: "hacknight-de5df.appspot.com",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialBinding: ControllerBindings(), home: WelcomeScreen());
  }
}
