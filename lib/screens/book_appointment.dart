// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:medical_health_firebase/Models/appointment_data.dart';
// import 'package:medical_health_firebase/screens/appointment_screen.dart';
// import 'package:medical_health_firebase/services/appointment_controller.dart';
// import 'package:medical_health_firebase/utils/appointment_card.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';

// class BookApointment extends StatefulWidget {
//   const BookApointment({super.key});

//   @override
//   State<BookApointment> createState() => _BookApointmentState();
// }

// class _BookApointmentState extends State<BookApointment> {
//   final appointmentController = Get.put(AppointmentController());
//   final nameController = TextEditingController();
//   DateTime selectedDate = DateTime.now();
//   List<String> availableTimeSlots = [
//     '9:00 AM - 9:30 AM',
//     '10:00 AM - 10:30 AM',
//     '11:00 AM - 11:30 AM',
//     '2:00 PM - 2:30 PM',
//     '3:00 PM - 3:30 PM',
//   ];

//   // String selectedTimeSlot = '';
//   Set<String> selectedTimeSlot = {};
//   List<String> bookedAppointments = [];
//   late SharedPreferences prefs;

//   // Future<void> loadSavedAppointments() async {
//   //   prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     selectedTimeSlot =
//   //         prefs.getStringList('selectedTimeSlots')?.toSet() ?? {};
//   //   });
//   // }

//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   Future.delayed(Duration.zero, () {
//   //     ModalRoute.of(context)!.onPopInvoked(() {
//   //       saveSelectedTimes();
//   //     } as bool);
//   //   });
//   // }
//   Future<String?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userId');
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Future<String?> userId = getUserId();
//     return Scaffold(
//       backgroundColor: const Color(0xFF7165D6),
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 44, 109, 230),
//         leading: GestureDetector(
//             onTap: () => Get.offAll(AppointmentScreen()),
//             child: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//             )),
//         centerTitle: true,
//         title: const Text(
//           'Book you appointment today',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: FutureBuilder(
//         future: getUserId(),
//         builder: (context, snapshot) {
//           return Column(children: [
//             // const SizedBox(
//             //   height: 20,
//             // ),
//             Expanded(
//               child: ListView.builder(
//                   itemCount: availableTimeSlots.length,
//                   itemBuilder: (context, index) {
//                     final timeSlot = availableTimeSlots[index];
//                     final isTimeSlotSelected =
//                         selectedTimeSlot.contains(timeSlot);
//                     if (index < availableTimeSlots.length) {
//                       return ListTile(
//                         title: Text(
//                           timeSlot,
//                           style: const TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             if (isTimeSlotSelected) {
//                               selectedTimeSlot.remove(timeSlot);
//                             } else {
//                               selectedTimeSlot.add(timeSlot);
//                             }
//                           });
//                         },
//                         tileColor: selectedTimeSlot.contains(timeSlot)
//                             ? Colors.blue.withOpacity(0.5)
//                             : null,
//                       );
//                     } else {
//                       return AppointmentScreen();
//                     }
//                   }),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Appointment type',
//                 fillColor: Colors.white,
//                 filled: true,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 ElevatedButton(
//                     onPressed: () async {
//                       _handleButton();
//                       showConfirmLog();
//                     },
//                     child: const Text('confirm Appointment')),
//               ],
//             ),

//             GetBuilder<AppointmentController>(
//               builder: (appointmentController) {
//                 return Expanded(
//                   child: GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2),
//                       itemCount: bookedAppointments.length,
//                       shrinkWrap: false,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (context, index) {
//                         final appointment =
//                             appointmentController.appointments[index];
//                         // return AppointmentCard(appointment: appointment);
//                         return Container(
//                           margin: const EdgeInsets.all(9.5),
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   spreadRadius: 2,
//                                 )
//                               ]),
//                           child: Column(
//                             children: [
//                               const Text('Your appointments'),
//                               const SizedBox(
//                                 height: 3,
//                               ),
//                               Text(DateFormat.yMMMd().format(appointment.dateTime ?? DateTime.now())),
//                               Text(bookedAppointments[index])
//                             ],
//                           ),
//                         );
//                       }),
//                 );
//               },
//             )
//           ]);
//         },
//       ),
//     );
//   }

//   void saveSelectedAppointments() {
//     prefs.setStringList('selectedTimeSlot', selectedTimeSlot.toList());
//   }

//   void showConfirmLog() {
//     if (selectedTimeSlot.isEmpty) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('No appointments selected'),
//               content: const Text('Please select at least one appointment.'),
//               actions: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Okay'))
//               ],
//             );
//           });
//     } else {
//       setState(() {
//         bookedAppointments.addAll(selectedTimeSlot);
//         selectedTimeSlot.clear();
//       });

//       appointmentController.update(bookedAppointments);
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Appointments booked'),
//               content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: selectedTimeSlot
//                       .map((timeSlot) =>
//                           Text('Your appointment at $timeSlot is booked'))
//                       .toList()),
//               actions: [
//                 ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Okay'))
//               ],
//             );
//           });
//     }
//   }

//   Future<void> saveSelectedTimes() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('selectedTime', selectedTimeSlot.toList());
//   }

//   Future<void> loadSelectedTimes() async {
//     final prefs = await SharedPreferences.getInstance();
//     final storedTime = prefs.getStringList('selectedTime');
//     if (storedTime != null) {
//       setState(() {
//         selectedTimeSlot = storedTime.toSet();
//       });
//     }
//   }

//   _handleButton() async {
//     String? userId = await getUserId();
//     if (userId != null) {
//       appointmentController.saveAppointments(Appointment(
//           id: const Uuid().v4(),
//           name: nameController.text,
//           userId: userId,
//           doctorId: null,
//           timeSlot: selectedDate.toString(),
//           dateTime: selectedDate), dateTime: selectedDate);
//     }
//   }
// }
