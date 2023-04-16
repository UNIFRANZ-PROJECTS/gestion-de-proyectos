import 'package:flutter/material.dart';
import 'package:gestion_projects/models/type_user.model.dart';

class TypeUsersDataSource extends DataTableSource {
  final Function(TypeUserModel) editTypeUser;
  final Function(TypeUserModel, bool) deleteTypeUser;
  final List<TypeUserModel> typeUsers;

  TypeUsersDataSource(this.typeUsers, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final TypeUserModel typeUser = typeUsers[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(typeUser.name)),
      DataCell(Text(typeUser.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(typeUser)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: typeUser.state,
                  onChanged: (state) => deleteTypeUser(typeUser, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => typeUsers.length;

  @override
  int get selectedRowCount => 0;
}
