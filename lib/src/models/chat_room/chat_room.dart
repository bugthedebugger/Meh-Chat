import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meh_chat/src/models/messasges/messages.dart';
import 'package:meh_chat/src/models/user/user.dart';

class ChatRoom with ChangeNotifier {
  String documentID;
  Timestamp lastChat;
  Messages messages;
  List participants;
  User from;

  ChatRoom(this.documentID, this.lastChat, this.messages, this.participants,
      this.from);

  ChatRoom.fromJson(Map<String, dynamic> json) {
    this.lastChat = json['last-chat'];
    this.messages = json['messages'];
    this.participants = json['participants'];
    this.from = json['from'];
    this.documentID = json['documentID'];
  }

  String toJson() {
    return json.encode({
      'last-chat': this.lastChat,
      'documentID': this.documentID,
      'messages': this.messages,
      'participants': this.participants,
      'from': this.from,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'last-chat': this.lastChat,
      'messages': messages?.toMap(),
      'participants': this.participants,
    };
  }
}
