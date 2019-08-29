import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/messasges/messages.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/chat_room_service/chat_room_events.dart';
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';

class ChatRoomService {
  StreamController<List<ChatRoom>> _roomStreamController =
      StreamController<List<ChatRoom>>.broadcast();
  Stream get roomStream => _roomStreamController.stream;
  Sink get _roomSink => _roomStreamController.sink;

  StreamController<ChatRoomEvents> _eventsController =
      StreamController<ChatRoomEvents>.broadcast();
  Stream get eventStream => _eventsController.stream;
  Sink get _eventSink => _eventsController.sink;

  final Firestore firestore;
  final UserHandler userHandler;
  User user;
  DocumentReference userReference;

  ChatRoomService(this.firestore, this.userHandler);

  void init() async {
    print(
        '--------------------------------init--------------------------------');
    List<ChatRoom> chatRoomLists = List<ChatRoom>();
    user = userHandler.getUser();
    userReference = user.document;
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
        if (chatRoomSnapshot.documents.length == 0) {
          addData(List<ChatRoom>());
        }
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

  void newChat(String email) async {
    dispatch(SearchUser());
    await firestore
        .collection('user-data')
        .where('email', isEqualTo: email)
        .getDocuments()
        .then((onValue) async {
      if (onValue.documents.length > 0) {
        ChatRoom tempChatRoom = ChatRoom.fromJson({
          'last-chat': Timestamp.now(),
          'participants': [userReference, onValue.documents.first.reference],
        });

        DocumentReference newChatRoomReference =
            await firestore.collection('chat-rooms').add(tempChatRoom.toMap());
        dispatch(UserFound(documentID: newChatRoomReference.documentID));
      } else {
        dispatch(UserNotFound());
      }
    });
  }

  void dispatch(ChatRoomEvents event) {
    _eventSink.add(event);
  }

  void addData(List<ChatRoom> data) {
    _roomSink.add(data);
  }

  void dispose() {
    _roomStreamController?.close();
    _eventsController?.close();
  }
}
