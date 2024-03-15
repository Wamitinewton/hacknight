import 'package:get/get.dart';

import '../services/appointment_controller.dart';
import '../services/authentication/signup_controller.dart';


class ControllerBindings extends Bindings{
  @override
  void dependencies (){
    Get.put<AuthController>(AuthController());
    Get.put(AppointmentController());
  }
}