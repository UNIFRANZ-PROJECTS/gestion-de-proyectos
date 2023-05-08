import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class TeachersDataSource extends DataTableSource {
  final Function(SubjectModel) editTypeUser;
  final Function(SubjectModel, bool) deleteTypeUser;
  final List<SubjectModel> categories;

  TeachersDataSource(this.categories, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final SubjectModel subject = categories[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(subject.code)),
      DataCell(Text(subject.name)),
      DataCell(Text('${subject.semester}')),
      DataCell(Text(subject.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(subject)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: subject.state,
                  onChanged: (state) => deleteTypeUser(subject, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
