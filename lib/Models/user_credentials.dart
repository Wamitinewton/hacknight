// class UserModel {
//   String? name;
//   String? email;
//   String? id;

//   UserModel({this.name, this.email, this.id});

//   UserModel.fromJson(Map<String, dynamic> json) {
//     name = json['name']?? '';
//     email = json['email']?? '';
//     id = json['id']?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['id'] = this.id;
//     return data;
//   }
// }

class UserModel {
  UserModel({this.id, this.email, this.password, this.name});

  UserModel.fromJson(dynamic json) {
    id = json['_id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
  }

  String? id;
  String? email;
  String? password;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['email'] = email;
    map['password'] = password;
    map['name'] = name;

    return map;
  }

  @override
  String toString() {
    return 'User{id: $id, email:$email, password:$password, name:$name}';
  }
}
