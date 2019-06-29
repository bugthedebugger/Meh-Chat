import 'package:flutter/material.dart';
import 'package:meh_chat/src/services/logout/logout_service.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class AllMessages extends StatelessWidget {
  final LogoutService _logoutService =
      kiwi.Container().resolve<LogoutService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: RaisedButton(
        onPressed: () {
          _logoutService.signOut();
        },
      ),
    );
  }
}
