import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class MessageSnippetWidget extends StatelessWidget {
  final String avatar;
  final String user;
  final String messageSnippet;
  final DateTime date;
  final Function onTap;

  const MessageSnippetWidget({
    Key key,
    @required this.avatar,
    @required this.user,
    @required this.messageSnippet,
    @required this.date,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String timeDifference;
    Duration timeDiffObject = DateTime.now().difference(date);

    if (timeDiffObject.inSeconds < 60) {
      timeDifference = '${timeDiffObject.inSeconds} s';
    } else if (timeDiffObject.inMinutes >= 1 && timeDiffObject.inMinutes < 60) {
      timeDifference = '${timeDiffObject.inMinutes} min';
    } else if (timeDiffObject.inHours >= 1 && timeDiffObject.inHours < 24) {
      timeDifference = '${timeDiffObject.inHours} hrs';
    } else if (timeDiffObject.inDays >= 1) {
      timeDifference = '${timeDiffObject.inDays} days';
    }

    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setWidth(ScreenSize.screenHeight),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(5),
          right: ScreenUtil().setHeight(5),
          bottom: ScreenUtil().setHeight(5),
          left: ScreenUtil().setHeight(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                avatar,
              ),
              minRadius: ScreenUtil().setWidth(25),
              maxRadius: ScreenUtil().setWidth(30),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(15),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '$user',
                        style: TextStyle(
                          fontSize: FontSize.fontSize14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Text(
                        '$timeDifference',
                        style: TextStyle(
                          fontSize: FontSize.fontSize12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: ScreenUtil().setHeight(135),
                    child: Text(
                      '$messageSnippet',
                      style: TextStyle(
                        fontSize: FontSize.fontSize12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
