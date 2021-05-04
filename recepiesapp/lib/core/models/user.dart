import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String userId;
  String userMail;
  String userAdSoyad;
  String userFotoUrl;

  UserModel({this.userId, this.userMail, this.userAdSoyad, this.userFotoUrl});

  factory UserModel.firabasedenUret(User user) {
    return UserModel(
      userId: user.uid,
      userMail: user.email,
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userMail = json['userMail'];
    userAdSoyad = json['userAdSoyad'];
    userFotoUrl = json['userFotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userMail'] = this.userMail;
    data['userAdSoyad'] = this.userAdSoyad;
    data['userFotoUrl'] = this.userFotoUrl;
    return data;
  }
}
