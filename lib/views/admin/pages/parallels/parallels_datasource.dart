import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class ParallelsDataSource extends DataTableSource {
  final Function(ParallelModel) editTypeUser;
  final Function(ParallelModel, bool) deleteTypeUser;
  final List<ParallelModel> parallels;

  ParallelsDataSource(this.parallels, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final ParallelModel parallel = parallels[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text('${parallel.name}')),
      DataCell(Text(parallel.subjectId.name)),
      DataCell(Text('${parallel.teacherId.name} ${parallel.teacherId.lastName}')),
      DataCell(Text(parallel.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(parallel)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: parallel.state,
                  onChanged: (state) => deleteTypeUser(parallel, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => parallels.length;

  @override
  int get selectedRowCount => 0;
}
