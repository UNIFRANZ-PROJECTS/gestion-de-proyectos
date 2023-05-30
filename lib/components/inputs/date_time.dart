import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
  DateTime currentDate = DateTime(1950, 1, 1);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ButtonDate(hintText: widget.hintText, onPressed: () => select(context)),
          ),
        ],
      ),
    );
  }

  select(BuildContext context) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[_buildDateTimePicker()],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Elegir'),
              onPressed: () {
                widget.selectTime!(currentDate);
                Navigator.of(context).pop();
              },
            ),
          );
        });
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
              mode: CupertinoDatePickerMode.date,
              initialDateTime: currentDate,
              onDateTimeChanged: (DateTime newDataTime) {
                setState(() => currentDate = newDataTime);
                widget.selectTime!(newDataTime);
              }),
        ));
  }
}
