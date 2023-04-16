import 'package:flutter/material.dart';

class NavbarAvatar extends StatelessWidget {
  const NavbarAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 30,
        height: 30,
        child: Image.network('https://dl.airtable.com/DH4ROlhgSVG6TpXY0xrI_large_Joel-Monegro-pic-458x458.jpg'),
      ),
    );
  }
}
