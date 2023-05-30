import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final String text;
  final Color colorText;
  final Function onPressed;
  final MaterialStateProperty<Color?>? backgroundColor;

  const CustomFlatButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.colorText = Colors.black,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(backgroundColor: backgroundColor),
        onPressed: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            style: TextStyle(color: colorText),
          ),
        ));
  }
}
