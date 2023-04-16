import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:gestion_projects/components/compoents.dart';

class DialogDatePicker extends StatefulWidget {
  final Function(String, String) range;
  const DialogDatePicker({Key? key, required this.range}) : super(key: key);

  @override
  State<DialogDatePicker> createState() => _DialogDatePickerState();
}

class _DialogDatePickerState extends State<DialogDatePicker> {
  String date1 = '';
  String date2 = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        date1 = DateFormat('yyyy/MM/dd').format(args.value.startDate).toString().replaceAll('/', '-');
        date2 = DateFormat('yyyy/MM/dd').format(args.value.endDate ?? args.value.startDate).replaceAll('/', '-');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        height: MediaQuery.of(context).size.width < MediaQuery.of(context).size.height
            ? MediaQuery.of(context).size.width * 1
            : MediaQuery.of(context).size.height * 0.8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selecciona un rango de fechas',
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: SfDateRangePicker(
                  showNavigationArrow: true,
                  // selectionTextStyle: TextStyle(color: ThemeProvider.themeOf(context).data.backgroundColor),
                  rangeTextStyle: const TextStyle(color: Colors.blue),
                  // headerStyle: DateRangePickerHeaderStyle(
                  //     textStyle: TextStyle(color: ThemeProvider.themeOf(context).data.accentColor)),
                  // yearCellStyle: DateRangePickerYearCellStyle(
                  //     textStyle: TextStyle(color: ThemeProvider.themeOf(context).data.accentColor)),
                  // monthViewSettings: DateRangePickerMonthViewSettings(
                  //     viewHeaderStyle: DateRangePickerViewHeaderStyle(
                  //         textStyle: TextStyle(color: ThemeProvider.themeOf(context).data.accentColor))),
                  // monthCellStyle: DateRangePickerMonthCellStyle(
                  //     textStyle: TextStyle(color: ThemeProvider.themeOf(context).data.accentColor)),
                  navigationMode: DateRangePickerNavigationMode.scroll,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonWhiteComponent(
                    text: 'Cancelar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ButtonComponent(
                      text: 'Elegir', onPressed: () => (date1 != '' && date2 != '') ? widget.range(date1, date2) : null)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
