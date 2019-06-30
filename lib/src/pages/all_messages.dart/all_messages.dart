import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/user/user.dart';
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

  User user;
  final UserHandler _userHandler = kiwi.Container().resolve<UserHandler>();
  DocumentReference _reference;

  @override
  void initState() {
    user = _userHandler.getUser();
    _reference = user.document;
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
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('chat-rooms')
              // .orderBy('last-chat', descending: true)
              .where(
                'participants',
                arrayContains: _reference,
              )
              .snapshots(),
          builder: (context, snapshot) {
            // print(snapshot.data);
            // print(user.reference);
            // print(user.document);
            if (snapshot.hasData) {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data.documents[index];
                  var data = doc.data;
                  DocumentReference senderDocument =
                      data['participants'].firstWhere((data) {
                    return data.documentID != _reference.documentID;
                  });

                  DocumentSnapshot sender;
                  senderDocument.get().then((onValue) {
                    sender = onValue;
                    print("My sender: ${sender?.data}");
                  });
                  print(
                      "////////////////////////My sender: ${sender?.data}/////////////////");
                  print(
                      '``````````````````````````````````````````````````````````````');
                  Firestore.instance
                      .collection('chat-rooms')
                      .document('rtNblm3LAZCkIjRMnmhv')
                      .get()
                      .then(
                    (onValue) {
                      print(onValue.data);
                    },
                  );
                  print(
                      '``````````````````````````````````````````````````````````````');
                  return MessageSnippetWidget(
                    avatar: '',
                    date: data['last-chat'].toDate(),
                    messageSnippet: 'A short message snippet',
                    user: user.name,
                    onTap: () {},
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          FontAwesomeIcons.plus,
          color: Theme.of(context).primaryColor,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.message,
              ),
            )
          ],
        ),
      ),
    );
  }
}
