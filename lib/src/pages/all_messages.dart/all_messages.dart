import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/logout/logout_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:meh_chat/src/services/user_handler.dart/user_handler.dart';
import 'package:meh_chat/src/widgets/logo/logo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class AllMessages extends StatefulWidget {
  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  final LogoutService _logoutService =
      kiwi.Container().resolve<LogoutService>();

  User user;
  final UserHandler _userHandler = kiwi.Container().resolve<UserHandler>();

  @override
  void initState() {
    user = _userHandler.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Logo(),
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
    );
  }
}
