import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:intl/intl.dart';

class SuscribesDataSource extends DataTableSource {
  final Function(SuscribeModel) printDocument;
  final Function(SuscribeModel, bool) deleteSuscribe;
  final List<SuscribeModel> suscribes;

  SuscribesDataSource(this.suscribes, this.printDocument, this.deleteSuscribe);

  @override
  DataRow getRow(int index) {
    final SuscribeModel suscribe = suscribes[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text('${suscribe.student.name} ${suscribe.student.lastName}')),
      DataCell(Text(suscribe.student.code)),
      DataCell(Text('${suscribe.responsible.name} ${suscribe.responsible.lastName}')),
      DataCell(Text(DateFormat(' dd, MMMM yyyy ').format(suscribe.createdAt))),
      DataCell(Text('${suscribe.total}')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.print, color: Colors.blue), onPressed: () => printDocument(suscribe)),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => suscribes.length;

  @override
  int get selectedRowCount => 0;
}
