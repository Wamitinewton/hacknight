// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../Models/appointment_data.dart';

// class AppointmentCard extends StatelessWidget {
//   final Appointment appointment;
//   final List<String> bookedAppointments;

//   const AppointmentCard({
//     super.key,
//     required this.appointment,
//     required this.bookedAppointments,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool isBooked = bookedAppointments.contains(appointment.timeSlot);

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text(appointment.name),
//             Text(DateFormat.yMMMd().format(appointment.dateTime)),
//             if (isBooked)
//               const Text('Booked', style: TextStyle(color: Colors.green)),
//           ],
//         ),
//       ),
//     );
//   }
// }
