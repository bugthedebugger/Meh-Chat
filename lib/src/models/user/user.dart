import 'dart:convert';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String name;
  String email;
  String uid;
  String avatar;

  User(this.name, this.email, this.uid, this.avatar);

  User.fromJson(Map<String, dynamic> data) {
    this.name = data['name'];
    this.email = data['email'];
    this.uid = data['uid'];
    this.avatar = data['avatar'];
    notifyListeners();
  }

  String toJson() {
    return json.encode(
      {
        'name': name,
        'email': email,
        'uid': uid,
        'avatar': avatar,
      },
    );
  }
}
