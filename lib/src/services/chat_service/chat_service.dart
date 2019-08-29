import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/message/message.dart';
import 'package:meh_chat/src/models/messasges/messages.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';

class ChatService {
  final Firestore firestore;
  final UserHandler userHandler;
  ChatService(this.firestore, this.userHandler);

  User user;
  DocumentReference userReference;
  DocumentReference chatRoomReference;

  StreamController<ChatRoom> _chatController =
      StreamController<ChatRoom>.broadcast();
  Stream get roomStream => _chatController.stream;
  Sink get _roomSink => _chatController.sink;

  StreamController<Messages> _messagesController =
      StreamController<Messages>.broadcast();
  Stream get messagesStream => _messagesController.stream;
  Sink get _messagesSink => _messagesController.sink;

  ChatRoom chatRoom;

  StreamSubscription _firestoreSub;

  Future init(String documentID) async {
    user = userHandler.getUser();
    userReference = user.document;

    _firestoreSub = firestore
        .document('chat-rooms/$documentID')
        .snapshots()
        .listen((document) async {
      chatRoomReference = document.reference;
      Timestamp lastChat = document.data['last-chat'];
      Messages messages = Messages.fromJson(document.data['messages']);
      List participants = document.data['participants'];
      DocumentSnapshot fromUserSnap = await participants
          .firstWhere((test) => test.documentID != userReference.documentID)
          .get();
      User from = User.fromJson({
        'avatar': fromUserSnap.data['avatar'],
        'email': fromUserSnap.data['email'],
        'name': fromUserSnap.data['name'],
        'reference': fromUserSnap.documentID,
      });

      chatRoom = ChatRoom.fromJson({
        'last-chat': lastChat,
        'documentID': document.documentID,
        'messages': messages,
        'participants': participants,
        'from': from,
      });
      roomData(chatRoom);
      addData(messages);
    });
  }

  Future send(String message) async {
    Message tempMessage = Message(
      userReference,
      message,
      false,
      Timestamp.now(),
    );

    chatRoom.lastChat = Timestamp.now();
    chatRoom.messages.messages.add(tempMessage);

    print(chatRoom.toMap());

    await firestore.runTransaction((Transaction tx) async {
      await tx.update(chatRoomReference, chatRoom.toMap());
    });

    return;
  }

  void addData(Messages messages) {
    _messagesSink.add(messages);
  }

  void roomData(ChatRoom data) {
    _roomSink.add(data);
  }

  void dispose() {
    _messagesController?.close();
    _chatController?.close();
    _firestoreSub?.cancel();
  }
}
