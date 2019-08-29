import 'package:flutter/material.dart';
import 'package:meh_chat/src/assets/assets.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController textController;
  final Function onPressed;
  final String hint;
  final Icon icon;

  const CustomInputField({
    Key key,
    @required this.textController,
    @required this.onPressed,
    @required this.hint,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        fillColor: Theme.of(context).primaryColor,
        filled: true,
        hintText: '$hint',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(30),
          ),
        ),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
