import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class FromChatWidget extends StatelessWidget {
  final String message;
  final DateTime date;

  FromChatWidget({
    Key key,
    @required this.message,
    @required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
              constraints: BoxConstraints(
                maxWidth: ScreenUtil().setWidth(300),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                  topRight: Radius.circular(ScreenUtil().setWidth(30)),
                  bottomRight: Radius.circular(ScreenUtil().setWidth(30)),
                ),
              ),
              child: Text(
                '$message',
                style: TextStyle(
                  fontSize: FontSize.fontSize12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(5),
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
