import 'package:flutter/material.dart';

ThemeData styleLigth() {
  return ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xfff2f2f2),
    appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black)),
    buttonTheme: ButtonThemeData(
        padding: const EdgeInsets.all(0),
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.accent),
    dialogBackgroundColor: const Color(0xfff2f2f2),
    dialogTheme: const DialogTheme().copyWith(
      backgroundColor: const Color(0xfff2f2f2),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xff21232A),
        surfaceTintColor: Colors.transparent,
        // shadowColor: Colors.red,
        backgroundColor: const Color(0xfff2f2f2),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
    textTheme: ThemeData.light()
        .textTheme
        .copyWith(
          bodyLarge: const TextStyle(color: Color(0xff21232A)),
          bodyMedium: const TextStyle(color: Color(0xff21232A)),
        )
        .apply(
          fontFamily: 'Poppins',
        ),
    inputDecorationTheme: ThemeData.light().inputDecorationTheme.copyWith(
          labelStyle: const TextStyle(color: Colors.grey),
          hintStyle: const TextStyle(color: Colors.grey),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Color(0xffFC5000))),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.grey, width: 2)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          iconColor: Colors.black,
          errorStyle: const TextStyle().apply(color: Colors.red, fontFamily: 'Poppins'),
        ),
  );
}
