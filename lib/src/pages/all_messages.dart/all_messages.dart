import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/chat_room_service/chat_room_service.dart';
import 'package:meh_chat/src/services/logout/logout_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';
import 'package:meh_chat/src/widgets/message_snippet_widget/message_snippet_widget.dart';

class AllMessages extends StatefulWidget {
  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  final LogoutService _logoutService =
      kiwi.Container().resolve<LogoutService>();
  final ChatRoomService _chatRoomService =
      kiwi.Container().resolve<ChatRoomService>();

  User user;
  final UserHandler _userHandler = kiwi.Container().resolve<UserHandler>();

  @override
  void initState() {
    user = _userHandler.getUser();
    _chatRoomService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: FontSize.fontSize18,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _logoutService.signOut().then((onValue) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.LOGIN,
                  (p) => false,
                );
              });
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: EdgeInsets.all(
            ScreenUtil().setWidth(5),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              user.avatar,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<ChatRoom>>(
        stream: _chatRoomService.roomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MessageSnippetWidget(
                  avatar: snapshot.data[index].from.avatar,
                  date: snapshot.data[index].lastChat.toDate(),
                  messageSnippet:
                      snapshot.data[index].messages.messages.last.message,
                  user: snapshot.data[index].from.name,
                  onTap: () {},
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
