import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/models/role.model.dart';
import 'package:gestion_projects/models/type_user.model.dart';
import 'package:gestion_projects/views/admin/users/add_info_users.dart';

import 'package:gestion_projects/views/admin/users/add_user.dart';
import 'package:gestion_projects/views/admin/users/users_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    callAllUsers();
    callAllRoles();
    callAllTypeUsers();
    super.initState();
  }

// UpdateListUser
  callAllUsers() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');
    CafeApi.configureDio();
    return CafeApi.httpGet(users(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['usuarios'])}');
      userBloc.add(UpdateListUser(listUserModelFromJson(json.encode(res.data['usuarios']))));
    });
  }

  callAllRoles() async {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    debugPrint('obteniendo todos los roles');
    CafeApi.configureDio();
    return CafeApi.httpGet(roles(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['roles'])}');
      rolBloc.add(UpdateListRol(rolesModelFromJson(json.encode(res.data['roles']))));
    });
  }

  callAllTypeUsers() async {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    debugPrint('obteniendo todos los tipos de usuarios');
    CafeApi.configureDio();
    return CafeApi.httpGet(typeUsers(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['tiposUsuarios'])}');
      typeUserBloc.add(UpdateListTypeUser(typeUserModelFromJson(json.encode(res.data['tiposUsuarios']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: true);
    final usersDataSource = UsersDataSource(
      userBloc.state.listUser,
      (typeUser) => showEditUser(context, typeUser),
      (typeUser, state) => removeUser(typeUser, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Usuarios'),
              ButtonComponent(text: 'Subir excel', onPressed: () => subirexcel(context)),
              ButtonComponent(text: 'Agregar nuevo Usuario', onPressed: () => showCreateUser(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: userBloc.state.ascending,
                  sortColumnIndex: userBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Email'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Tipo de Usuario'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Rol'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    const DataColumn(label: Text('Carreras')),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: usersDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  void subirexcel(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(
              component: AddUsersData(),
            ));
  }

  showCreateUser(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddUserForm()));
  }

  showEditUser(BuildContext context, UserModel typeUser) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddUserForm(item: typeUser)));
  }

  removeUser(UserModel user, bool state) {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(users(user.id), formData).then((res) async {
      final user = userModelFromJson(json.encode(res.data['usuario']));
      userBloc.add(UpdateItemUser(user));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
