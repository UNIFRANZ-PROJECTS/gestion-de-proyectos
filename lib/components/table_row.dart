import 'package:flutter/material.dart';

TableRow tableInfo(String text, String text2) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.right,
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Text(text2),
    ),
  ]);
}
