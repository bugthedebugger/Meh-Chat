import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  DocumentReference fromReference;
  String message;
  bool seen;
  Timestamp time;

  Message(this.fromReference, this.message, this.seen, this.time);

  Message.fromJson(Map<dynamic, dynamic> json) {
    this.fromReference = json['from'];
    this.seen = json['seen'];
    this.message = json['message'];
    this.time = json['time'];
  }

  String toJson() {
    return json.encode({
      'from': this.fromReference,
      'seen': this.seen,
      'message': this.message,
      'time': this.time,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'from': this.fromReference,
      'seen': this.seen,
      'message': this.message,
      'time': this.time,
    };
  }
}
