import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';
import 'package:meh_chat/src/widgets/from_chat_widget/from_chat_widget.dart';
import 'package:meh_chat/src/widgets/to_chat_widget/to_chat_widget.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(
      width: ScreenSize.screenWidth,
      height: ScreenSize.screenWidth,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'User name',
          style: TextStyle(
            fontSize: FontSize.fontSize18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(ScreenSize.screenWidth),
              height: ScreenUtil().setHeight(274),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(30)),
                  topRight: Radius.circular(ScreenUtil().setWidth(30)),
                ),
              ),
              child: ListView.builder(
                reverse: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ToChatWidget();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setHeight(10),
              ),
              color: Colors.white,
              alignment: Alignment.center,
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                  hintText: 'Message ...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      print(_textController.text);
                      _textController.clearComposing();
                      _textController.clear();
                      print('tapped');
                    },
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
