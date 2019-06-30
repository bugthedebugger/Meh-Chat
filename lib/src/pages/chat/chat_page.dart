import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/chat_room/chat_room.dart';
import 'package:meh_chat/src/models/messasges/messages.dart';
import 'package:meh_chat/src/services/chat_service/chat_service.dart';
import 'package:meh_chat/src/widgets/from_chat_widget/from_chat_widget.dart';
import 'package:meh_chat/src/widgets/to_chat_widget/to_chat_widget.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String documentID;

  const ChatPage({Key key, @required this.documentID}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _textController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final ChatService _chatService = kiwi.Container().resolve<ChatService>();

  @override
  void initState() {
    _chatService.init(widget.documentID);
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    _chatService?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);

    return StreamBuilder<ChatRoom>(
        stream: _chatService.roomStream,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                snapshot.hasData ? snapshot.data.from.name : 'User name',
                style: TextStyle(
                  fontSize: FontSize.fontSize18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(ScreenSize.screenWidth),
                    height: ScreenUtil().setHeight(274),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                        topRight: Radius.circular(ScreenUtil().setWidth(30)),
                      ),
                    ),
                    child: StreamBuilder<Messages>(
                      stream: _chatService.messagesStream,
                      builder: (context, messagesSnapshot) {
                        if (messagesSnapshot.hasData) {
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: messagesSnapshot.data.messages.length,
                            itemBuilder: (context, index) {
                              if ('/user-data/' +
                                      messagesSnapshot.data.messages[index]
                                          .fromReference.documentID ==
                                  snapshot.data.from.reference) {
                                return FromChatWidget(
                                  message: messagesSnapshot
                                      .data.messages[index].message,
                                  date: messagesSnapshot
                                      .data.messages[index].time
                                      .toDate(),
                                );
                              } else {
                                return ToChatWidget(
                                  message: messagesSnapshot
                                      .data.messages[index].message,
                                  date: messagesSnapshot
                                      .data.messages[index].time
                                      .toDate(),
                                );
                              }
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20),
                      vertical: ScreenUtil().setHeight(10),
                    ),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).primaryColor,
                        filled: true,
                        hintText: 'Message ...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(_textController.text);

                            _scrollController.animateTo(
                              0,
                              curve: Curves.ease,
                              duration: Duration(milliseconds: 300),
                            );
                            print('tapped');
                            if (_textController.text.length > 0)
                              _chatService.send(_textController.text);
                            _textController.clear();
                          },
                          icon: Icon(
                            FontAwesomeIcons.paperPlane,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
