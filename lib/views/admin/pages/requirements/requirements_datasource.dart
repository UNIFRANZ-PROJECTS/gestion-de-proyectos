import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class RequirementsDataSource extends DataTableSource {
  final Function(RequirementModel) editRequirement;
  final Function(RequirementModel, bool) deleteRequirement;
  final List<RequirementModel> requirements;

  RequirementsDataSource(this.requirements, this.editRequirement, this.deleteRequirement);

  @override
  DataRow getRow(int index) {
    final RequirementModel requirement = requirements[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(requirement.name)),
      DataCell(Text(requirement.description)),
      DataCell(Text(requirement.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editRequirement(requirement)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: requirement.state,
                  onChanged: (state) => deleteRequirement(requirement, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => requirements.length;

  @override
  int get selectedRowCount => 0;
}
