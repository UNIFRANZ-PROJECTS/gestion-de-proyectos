import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool stateLoading;
  const ButtonComponent({Key? key, required this.text, required this.onPressed, this.stateLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        minWidth: 200,
        padding: const EdgeInsets.symmetric(vertical: 19),
        color: const Color(0xffFC5000),
        disabledColor: Colors.grey,
        onPressed: onPressed,
        child: stateLoading
            ? Center(
                child: Image.asset(
                'assets/images/load.gif',
                fit: BoxFit.cover,
                height: 20,
              ))
            : Center(
                child: Text(text,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ),
      ),
    );
  }
}

class ButtonIconComponent extends StatelessWidget {
  final Widget icon;
  final String text;
  final Function()? onPressed;
  final bool stateLoading;
  const ButtonIconComponent(
      {Key? key, required this.icon, required this.text, required this.onPressed, this.stateLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xffFC5000),
      disabledColor: Colors.grey,
      onPressed: onPressed,
      child: stateLoading
          ? Center(
              child: Image.asset(
              'assets/images/load.gif',
              fit: BoxFit.cover,
              height: 20,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: icon,
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                    child: Text(text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
              ],
            ),
    );
  }
}

class ButtonWhiteComponent extends StatelessWidget {
  final String text;
  final Color? colorText;
  final Function()? onPressed;
  const ButtonWhiteComponent({Key? key, required this.text, required this.onPressed, this.colorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: MaterialButton(
            onPressed: onPressed,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }
}

class ButtonDate extends StatelessWidget {
  final String hintText;
  final Color? colorText;
  final FontWeight? fontWeight;
  final bool iconState;
  final Function() onPressed;
  final bool statecorrect;

  const ButtonDate({
    Key? key,
    required this.hintText,
    required this.onPressed,
    this.iconState = false,
    this.colorText,
    this.fontWeight,
    this.statecorrect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      focusElevation: 0,
      onPressed: onPressed,
      color: Colors.transparent,
      splashColor: Colors.transparent,
      highlightElevation: 0,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      hoverElevation: 0,
      focusColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.grey, width: 0.5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
        child: SizedBox(
          width: double.infinity,
          child: Text(hintText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              )),
        ),
      ),
    );
  }
}

class NumberComponent extends StatelessWidget {
  final String text;
  final bool iconColor;
  const NumberComponent({Key? key, required this.text, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      elevation: 2.0,
      fillColor: iconColor ? const Color(0xffFC5000) : Colors.white,
      shape: const CircleBorder(),
      child: Text(
        text,
        style: TextStyle(color: iconColor ? Colors.white : Colors.black),
      ),
    );
  }
}
