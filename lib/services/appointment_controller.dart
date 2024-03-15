import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/Models/appointments_model.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload appointment method

  Future<void> uploadAppointment(AppointmentModel appointmentModel) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      // generate a unique ID for the appointment

      var appointmentRef = _firestore.collection('appointments').doc();
      // set the appointment data using the generated document ID
      await appointmentRef.set(appointmentModel.toJson());
      // await _firestore
      //     .collection('appointments')
      //     .doc(userId)
      //     .set(appointmentModel.toJson());
      Get.snackbar('Success', 'Appointment uploaded successfully');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'An unknown error occurred');
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred');
    }
  }
  // update appintments in firebase

  Future<void> updateAppointment(
      String appointmentId, AppointmentModel updatedAppointment) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }
      await _firestore
          .collection('appointments')
          .doc(userId)
          .update(updatedAppointment.toJson());
      Get.snackbar('Success', 'Appointment updated successfully');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'An unknown error has ocurred');
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred');
    }
  }

  //delete appointments from database

  Future<void> deleteAppointments(String appointmentId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      //Get a reference to the user's appointments collection
      var appointmentCollection = _firestore
          .collection('appointments')
          .doc(userId)
          .collection('user_appointments');
      //Get a list of all appointment documents
      var appointments = await appointmentCollection.get();

      // loop through each appointment document and delete it

      for (var appointment in appointments.docs) {
        await appointment.reference.delete();
      }
      // await _firestore.collection('appointments').doc(userId).delete();
      Get.snackbar('Success', 'Appointment deleted successfully');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'An unkown has occurred');
    } catch (e) {
      Get.snackbar('Error', 'An unknown error occurred');
    }
  }

  // Fetch all appointments from database
  Stream<List<AppointmentModel>> getAppointments() {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      Get.snackbar('Error', 'User not logged in');
      // return an empty stream if the user is not logged in
      return Stream.value([]);
    }

    // get reference to the user's appointments collection
    var appointmentCollection = _firestore
        .collection('appointments')
        .doc(userId)
        .collection('user_appointments');

    // listen for changes in the user's appointments collection

    return appointmentCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList());

    // return _firestore.collection('appointments').snapshots().map((snapshot) =>
    //     snapshot.docs
    //         .map((doc) => AppointmentModel.fromJson(doc.data()))
    //         .toList());
  }
}
