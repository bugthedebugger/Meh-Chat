import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/messasges/messages.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';

class ChatRoomService {
  StreamController<List<ChatRoom>> _roomStreamController =
      StreamController<List<ChatRoom>>.broadcast();
  Stream get roomStream => _roomStreamController.stream;
  Sink get _roomSink => _roomStreamController.sink;

  final Firestore firestore;
  final UserHandler userHandler;

  ChatRoomService(this.firestore, this.userHandler);

  void init() async {
    print(
        '--------------------------------init--------------------------------');
    List<ChatRoom> chatRoomLists = List<ChatRoom>();
    User user = userHandler.getUser();
    DocumentReference userReference = user.document;
    print(userReference.path);
    firestore
        .collection('chat-rooms')
        .where(
          'participants',
          arrayContains: userReference,
        )
        .snapshots()
        .listen(
      (chatRoomSnapshot) {
        chatRoomLists.clear();
        print(chatRoomSnapshot.documents.length);
        chatRoomSnapshot.documents.forEach((document) async {
          print(document);
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
          });

          chatRoomLists.add(
            ChatRoom.fromJson({
              'last-chat': lastChat,
              'documentID': document.documentID,
              'messages': messages,
              'participants': participants,
              'from': from,
            }),
          );
          addData(chatRoomLists);
        });
      },
    );

    print(
        '--------------------------------end-init--------------------------------');
  }

  void addData(List<ChatRoom> data) {
    _roomSink.add(data);
  }

  void dispose() {
    // _roomStreamController?.close();
  }
}
