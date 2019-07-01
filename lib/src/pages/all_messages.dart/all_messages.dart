import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/chat_room_service/chat_room_events.dart';
import 'package:meh_chat/src/services/chat_room_service/chat_room_service.dart';
import 'package:meh_chat/src/services/logout/logout_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';
import 'package:meh_chat/src/widgets/custom_input_field/custom_input_field.dart';
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

  bool userFound = false;
  bool searchingUser = false;
  String userMessage = 'Search user first ...';

  User user;
  final UserHandler _userHandler = kiwi.Container().resolve<UserHandler>();
  final TextEditingController _textController = TextEditingController();
  StreamSubscription _sub;

  @override
  void initState() {
    user = _userHandler.getUser();
    _chatRoomService.init();
    _sub = _chatRoomService.eventStream.listen((onData) {
      if (onData is SearchUser) {
        setState(() {
          searchingUser = true;
        });
      } else if (onData is UserFound) {
        setState(() {
          searchingUser = false;
          userMessage = 'User found ...';
          userFound = true;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          AppRoutes.CHAT_PAGE,
          arguments: onData.documentID,
        );
      } else if (onData is UserNotFound) {
        setState(() {
          searchingUser = false;
          userMessage = 'User not found ...';
          userFound = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
          print(snapshot);
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MessageSnippetWidget(
                  avatar: snapshot.data[index].from.avatar,
                  date: snapshot.data[index].lastChat.toDate(),
                  messageSnippet: snapshot.data[index].messages.messages.isEmpty
                      ? '...'
                      : snapshot.data[index].messages.messages.last.message,
                  user: snapshot.data[index].from.name,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.CHAT_PAGE,
                      arguments: snapshot.data[index].documentID,
                    );
                  },
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
        onPressed: () {
          userFound = false;
          searchingUser = false;
          userMessage = 'Search user first ...';
          _textController.clear();

          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ScreenUtil().setWidth(30),
                  ),
                ),
                child: Container(
                  width: ScreenUtil().setWidth(300),
                  height: ScreenUtil().setHeight(80),
                  padding: EdgeInsets.all(
                    ScreenUtil().setHeight(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      CustomInputField(
                        textController: _textController,
                        hint: 'Search user ...',
                        icon: Icon(
                          FontAwesomeIcons.search,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          if (_textController.text.length > 0) {
                            _chatRoomService.newChat(_textController.text);
                          }
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      !searchingUser
                          ? userFound
                              ? Text(
                                  'User found ...',
                                  style: TextStyle(
                                    fontSize: FontSize.fontSize12,
                                  ),
                                )
                              : Text(
                                  '$userMessage',
                                  style: TextStyle(
                                    fontSize: FontSize.fontSize12,
                                  ),
                                )
                          : SizedBox(
                              height: ScreenUtil().setWidth(20),
                              width: ScreenUtil().setWidth(20),
                              child: CircularProgressIndicator(),
                            ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
