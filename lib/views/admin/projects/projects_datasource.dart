import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class ProjectDataSource extends DataTableSource {
  final Function(ProjectModel) editTypeUser;
  final Function(ProjectModel, bool) deleteTypeUser;
  final List<ProjectModel> projects;
  final Function(ProjectModel) showSubjects;
  final Function(ProjectModel) showStudents;

  ProjectDataSource(this.projects, this.editTypeUser, this.deleteTypeUser, this.showSubjects, this.showStudents);

  @override
  DataRow getRow(int index) {
    final ProjectModel project = projects[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(project.name)),
      DataCell(Text(project.category.name)),
      DataCell(Text(project.typeProyect.name)),
      DataCell(Text(project.description)),
      DataCell(Text(project.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.remove_red_eye_rounded), onPressed: () => showSubjects(project)),
          IconButton(icon: const Icon(Icons.remove_red_eye_rounded), onPressed: () => showStudents(project)),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(project)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: project.state,
                  onChanged: (state) => deleteTypeUser(project, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => projects.length;

  @override
  int get selectedRowCount => 0;
}
