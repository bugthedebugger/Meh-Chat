import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class ToChatWidget extends StatelessWidget {
  final String message;
  final DateTime date;

  ToChatWidget({Key key, @required this.message, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: ScreenUtil().setWidth(300),
              ),
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(10),
                bottom: ScreenUtil().setWidth(10),
                right: ScreenUtil().setWidth(10),
                left: ScreenUtil().setWidth(15),
              ),
              margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                  topRight: Radius.circular(ScreenUtil().setWidth(30)),
                  bottomLeft: Radius.circular(ScreenUtil().setWidth(30)),
                ),
              ),
              child: Text(
                '$message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FontSize.fontSize12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(5),
            bottom: ScreenUtil().setWidth(5),
          ),
          child: Text(
            '${date.toLocal()}',
            style: TextStyle(
              fontSize: FontSize.fontSize12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
