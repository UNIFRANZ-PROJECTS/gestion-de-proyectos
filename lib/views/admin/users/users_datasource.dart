import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

class UsersDataSource extends DataTableSource {
  final Function(UserModel) editUser;
  final Function(UserModel, bool) deleteUser;
  final List<UserModel> users;

  UsersDataSource(this.users, this.editUser, this.deleteUser);

  @override
  DataRow getRow(int index) {
    final UserModel user = users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.name)),
      DataCell(Text(user.email)),
      DataCell(Text(user.typeUser.name)),
      DataCell(Text(user.rol.name)),
      DataCell(IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () {})),
      DataCell(Text(user.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editUser(user)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: user.state,
                  onChanged: (state) => deleteUser(user, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
