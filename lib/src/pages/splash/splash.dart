import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300)).then((val) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.LOGIN,
        (predicate) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
