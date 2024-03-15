import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hacknight_project/Models/appointments_model.dart';
import 'package:hacknight_project/screens/custom_flat_button.dart';
import 'package:hacknight_project/services/appointment_controller.dart';
import 'package:hacknight_project/utils/schedule_card.dart';
import 'package:hacknight_project/utils/textfield_util.dart';

import '../utils/schedule.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final AppointmentController _appointmentController =
      Get.put(AppointmentController());
  static List<String> availableTimeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
  ];
  static final RxString selectedTime = ''.obs;
  static final TextEditingController diagnosis = TextEditingController();
  static final TextEditingController payment = TextEditingController();
  static final TextEditingController time = TextEditingController();
  static final RxList<Schedule> schedules = <Schedule>[].obs;

  @override
  void initState() {
    super.initState();
    // Initialize selectedTime with the first item in availableTimeSlots
    selectedTime.value =
        availableTimeSlots.isNotEmpty ? availableTimeSlots.first : '';

    _appointmentController.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TextUtil(
              onSuffixTap: () {
                _showTimePickerDialog(context);
              },
              controller: time,
              hintText: "Choose your time frame",
              labelText: "Time",
              suffixIcon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextUtil(
              onSuffixTap: () => diagnosis.clear(),
              controller: diagnosis,
              hintText: "Diagnosis required",
              labelText: "Diagnosis",
              suffixIcon: const Icon(
                Icons.clear_all_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextUtil(
              onSuffixTap: () => payment.clear(),
              controller: payment,
              hintText: "Method of payment",
              labelText: "Payment",
              suffixIcon: const Icon(
                Icons.clear_all,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: CustomFlatButton(
                  textColor: Colors.white,
                  onTap: () {
                    _addSchedule();
                  },
                  text: "confirm schedule",
                  color: Colors.green),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: schedules.isEmpty
                    ? const Center(
                        child: Text(
                          'No appointments booked',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Obx(
                        () => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: schedules.length,
                            itemBuilder: (context, index) {
                              final schedule = schedules[index];
                              return ScheduleCard(
                                schedule: schedule,
                                onDelete: () => _removeSchedule(index),
                                // time: schedule.time,
                                // diagnosis: schedule.diagnosis,
                                // payment: schedule.payment
                              );
                            }),
                      ))
          ],
        ),
      ),
    );
  }

  void _removeSchedule(int index) {
    schedules.removeAt(index);
  }

  void _showTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Time'),
          content: DropdownButton<String>(
            value: selectedTime.value,
            icon: const Icon(Icons.arrow_drop_down),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedTime.value = newValue;
                time.text = newValue;

                Navigator.of(context).pop();
              }
            },
            items: availableTimeSlots
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _addSchedule() {
    final time = selectedTime.value;
    final diagnosisText = diagnosis.text;
    final paymentText = payment.text;

    if (time.isNotEmpty && diagnosisText.isNotEmpty && paymentText.isNotEmpty) {
      final newAppointment = AppointmentModel(
          time: time, diagnosis: diagnosisText, payment: paymentText);

      _appointmentController.uploadAppointment(newAppointment);
      setState(() {
        schedules.add(Schedule(
            time: time, diagnosis: diagnosisText, payment: paymentText));
      });
      diagnosis.clear();
      payment.clear();
    } else {
      Get.snackbar('Error', 'Please fill out all required fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
