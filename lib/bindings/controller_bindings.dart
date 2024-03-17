import 'package:get/get.dart';

import '../services/appointment_controller.dart';
import '../services/authentication/auth_controller.dart';


class ControllerBindings extends Bindings{
  @override
  void dependencies (){
    Get.put<AuthController>(AuthController());
    Get.put(AppointmentController());
  }
}