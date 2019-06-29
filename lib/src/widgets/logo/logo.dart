import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);

    return Text(
      'Meh-Chat',
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: FontSize.fontSize32,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
