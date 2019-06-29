import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/pages/login/login.dart';
import 'package:meh_chat/src/pages/splash/splash.dart';

void main() => runApp(MehChat());

class MehChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meh-Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Color(AppColors.ACCENT),
        primaryColor: Color(AppColors.PRIMARY),
        fontFamily: 'Montserrat',
      ),
      routes: {
        AppRoutes.SPLASH_SCREEN: (context) => SplashScreen(),
        AppRoutes.LOGIN: (context) => Login(),
      },
    );
  }
}
