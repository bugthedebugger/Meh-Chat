import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class ToChatWidget extends StatelessWidget {
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
              width: ScreenUtil().setWidth(300),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                  topRight: Radius.circular(ScreenUtil().setWidth(30)),
                  bottomLeft: Radius.circular(ScreenUtil().setWidth(30)),
                ),
              ),
              child: Text(
                'My super duper awesome message will appear here :D',
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
            '5:58 PM',
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
