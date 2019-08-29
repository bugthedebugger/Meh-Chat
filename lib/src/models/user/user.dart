import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String name;
  String email;
  String uid;
  String avatar;
  String reference;
  bool me = true;

  DocumentReference get document => Firestore.instance.document(reference);

  User(this.name, this.email, this.uid, this.avatar, this.reference);

  User.fromJson(Map<String, dynamic> data) {
    this.name = data['name'];
    this.email = data['email'];
    this.uid = data['uid'];
    this.avatar = data['avatar'];
    this.reference = '/user-data/${data["reference"]}';
    this.me = data['me'];
    notifyListeners();
  }

  String toJson() {
    return json.encode(
      {
        'name': name,
        'email': email,
        'uid': uid,
        'avatar': avatar,
        'reference': reference,
        'me': me,
      },
    );
  }
}
