// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Appointment {
//   final String? id;
//   final String userId;
//   final String? doctorId;
//   final String timeSlot;
//   final DateTime dateTime;
//   final String name;

//   Appointment( {
//     required this.id,
//    required this.name,
//     required this.userId,
//     required this.doctorId,
//     required this.timeSlot,
//     required this.dateTime,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name':name,
//       'id': id,
//       'userId': userId,
//       'doctorId': doctorId,
//       'timeSlot': timeSlot,
//       'appointmentDate': dateTime.toIso8601String(),
//     };
//   }

//   factory Appointment.fromMap(Map<String, dynamic> map, Map<String, dynamic>? data) {
//     return Appointment(
//       id: map['id'],
//       userId: map['userId'],
//       doctorId: map['doctorId'],
//       timeSlot: map['timeSlot'],
//       dateTime: DateTime.parse(map['appointmentDate']), 
//       name: map['name'],
//     );
//   }
// }
