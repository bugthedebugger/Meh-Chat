import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/models/user/user.dart';
import 'package:meh_chat/src/services/login/login.dart';
import 'package:meh_chat/src/widgets/logo/logo.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user;
  LoginService _loginService = kiwi.Container().resolve<LoginService>();

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 500)).then((val) {
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //     AppRoutes.LOGIN,
    //     (predicate) => false,
    //   );
    // });
    _loginService.checkLogin().then((onValue) {
      if (onValue == true) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.ALL_MESSAGE,
          (predicate) => false,
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.LOGIN,
          (predicate) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider<User>.value(
      value: user,
      child: Scaffold(
        body: Center(
          child: Logo(),
        ),
      ),
    );
  }
}
