import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class TeachersDataSource extends DataTableSource {
  final Function(SubjectModel) editTypeUser;
  final Function(SubjectModel, bool) deleteTypeUser;
  final List<SubjectModel> categories;

  TeachersDataSource(this.categories, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final SubjectModel teacher = categories[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(teacher.name)),
      DataCell(Text('${teacher.semester}')),
      DataCell(Text(teacher.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(teacher)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: teacher.state,
                  onChanged: (state) => deleteTypeUser(teacher, state)))
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
