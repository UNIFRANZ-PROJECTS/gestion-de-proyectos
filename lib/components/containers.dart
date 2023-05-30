import 'package:flutter/material.dart';

class ContainerComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final bool? stateBorder;
  final double radius;
  const ContainerComponent(
      {Key? key, required this.child, this.width, this.height, this.color, this.stateBorder = true, this.radius = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: (color == null) ? null : color,
              // border: Border.all(color: Colors.grey),
            ),
            child: child));
  }
}
