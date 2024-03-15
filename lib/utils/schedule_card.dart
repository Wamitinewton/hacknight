import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/services/appointment_controller.dart';
import 'package:hacknight_project/utils/schedule.dart';


class ScheduleCard extends StatelessWidget {
  // final String time;
  // final String diagnosis;
  // final String payment;
  final Schedule schedule;
  final VoidCallback onDelete;
  final AppointmentController controller = Get.find<AppointmentController>();
  ScheduleCard(
      {super.key,
      // required this.time,
      // required this.diagnosis,
      // required this.payment,
      required this.schedule,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      // onDismissed: (direction) => onDelete(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (_) async {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('confirm'),
                content: const Text(
                    'Are you sure you want to delete the appointment?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        onDelete();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Delete'))
                ],
              );
            });
      },
      onDismissed: (direction) {
        controller.deleteAppointments(schedule.id!);
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Appointment deleted'),
          action: SnackBarAction(label: 'Undo', onPressed: () {}),
        ));
      },

      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time: ${schedule.time}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Diagnosis:${schedule.diagnosis}'),
              Text('payment: ${schedule.payment}')
            ],
          ),
        ),
      ),
    );
  }
}
