import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:gestion_projects/components/compoents.dart';

class DateTimeWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String, String)? selectDate;
  final Function(DateTime)? selectTime;
  const DateTimeWidget({super.key, required this.labelText, required this.hintText, this.selectDate, this.selectTime});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  List<DateTime> fechas = [];
  // String text = '';
  DateTime currentDate = DateTime(1950, 1, 1);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonDate(hintText: widget.hintText, onPressed: () => select(context)),
        ),
      ],
    );
  }

  select(BuildContext context) {
    if (widget.selectDate != null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return FadeIn(child: DialogDatePicker(
              range: (String date1, String date2) async {
                widget.selectDate!(date1, date2);
                Navigator.of(context).pop();
              },
            ));
          });
    }
    if (widget.selectTime != null) {
      showCupertinoModalPopup<String>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: <Widget>[_buildDateTimePicker()],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Elegir'),
                onPressed: () {
                  // setState(() => text = DateFormat(' HH:mm ', "es_ES").format(currentDate));
                  widget.selectTime!(currentDate);
                  Navigator.of(context).pop();
                },
              ),
            );
          });
    }
  }

  Widget _buildDateTimePicker() {
    return SizedBox(
        height: 200,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: currentDate,
              onDateTimeChanged: (DateTime newDataTime) {
                setState(() {
                  // text = DateFormat(' HH:mm ', "es_ES").format(newDataTime);
                  currentDate = newDataTime;
                });
                widget.selectTime!(newDataTime);
              }),
        ));
  }
}
