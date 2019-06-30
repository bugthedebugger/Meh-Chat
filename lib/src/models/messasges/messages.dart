import 'dart:convert';

import 'package:meh_chat/src/models/message/message.dart';

class Messages {
  List<Message> messages;

  Messages(this.messages);

  Messages.fromJson(List<dynamic> json) {
    List<Message> tempMessages = List<Message>();
    json.forEach((message) {
      tempMessages.add(Message.fromJson(message));
    });
    this.messages = tempMessages;
  }

  String toJson() {
    return json.encode({
      'messages': this.messages,
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'messages': this.messages,
    };
  }
}
