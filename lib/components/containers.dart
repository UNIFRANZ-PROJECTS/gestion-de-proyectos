import 'package:flutter/material.dart';
// import 'package:theme_provider/theme_provider.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool? stateBorder;
  const ContainerComponent(
      {Key? key, required this.child, this.width, this.height, this.color, this.stateBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
            elevation: 4,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: (color == null) ? null : color,
                  // border: Border.all(color: Colors.grey),
                ),
                child: child)));
  }
}
