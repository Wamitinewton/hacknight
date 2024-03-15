// class AvatarReference {
//   AvatarReference(this.downloadUrl);
//   final String downloadUrl;

//   factory AvatarReference.fromMap(Map<String, dynamic> data) {
//     if (data == null) {
      
//     }
//     final String downloadUrl = data['downloadUrl'];
//     if (downloadUrl == null) {
     
//     }
//     return AvatarReference(downloadUrl);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'downloadUrl': downloadUrl,
//     };
//   }
// }
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: AppointmentsScreen(),
  ));
}

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<String> availableTimeSlots = [
    '9:00 AM - 9:30 AM',
    '10:00 AM - 10:30 AM',
    '11:00 AM - 11:30 AM',
    '2:00 PM - 2:30 PM',
    '3:00 PM - 3:30 PM',
  ];

  String selectedTimeSlot = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: ListView.builder(
        itemCount: availableTimeSlots.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(availableTimeSlots[index]),
            onTap: () {
              setState(() {
                selectedTimeSlot = availableTimeSlots[index];
              });

              // You can add your logic to book the appointment here
              // For example, call a function to book the appointment with the selected time slot
              // bookAppointment(selectedTimeSlot);

              // Show a confirmation dialog or navigate to another screen
              showConfirmationDialog();
            },
          );
        },
      ),
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Booked'),
          content: Text('Your appointment at $selectedTimeSlot is booked.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
