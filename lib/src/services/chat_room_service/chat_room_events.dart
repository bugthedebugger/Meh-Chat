abstract class ChatRoomEvents {}

class SearchUser extends ChatRoomEvents {}

class UserFound extends ChatRoomEvents {
  String documentID;

  UserFound({this.documentID});
}

class CreateChatRoom extends ChatRoomEvents {}

class UserNotFound extends ChatRoomEvents {}
