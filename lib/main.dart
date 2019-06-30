import 'package:flutter/material.dart';
import 'package:meh_chat/dependencies.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/pages/all_messages.dart/all_messages.dart';
import 'package:meh_chat/src/pages/chat/chat_page.dart';
import 'package:meh_chat/src/pages/login/login.dart';
import 'package:meh_chat/src/pages/splash/splash.dart';

void main() async {
  await initKiwi();
  runApp(MehChat());
}

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
      darkTheme: ThemeData(
        accentColor: Color(AppColors.ACCENT),
        primaryColor: Colors.black,
        fontFamily: 'Montserrat',
        brightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      routes: {
        AppRoutes.SPLASH_SCREEN: (context) => SplashScreen(),
        AppRoutes.LOGIN: (context) => Login(),
        AppRoutes.ALL_MESSAGE: (context) => AllMessages(),
        AppRoutes.CHAT_PAGE: (context) => ChatPage(),
      },
    );
  }
}
