class AppointmentModel {
  String? time;
  String? diagnosis;
  String? payment;
  String? id;

  AppointmentModel({this.time, this.diagnosis, this.payment, this.id});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    diagnosis = json['diagnosis'];
    payment = json['payment'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['diagnosis'] = diagnosis;
    data['payment'] = payment;
    data['id'] = id;
    return data;
  }
}
