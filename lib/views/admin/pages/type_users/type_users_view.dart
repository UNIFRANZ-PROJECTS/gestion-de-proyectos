import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/type_user.model.dart';
import 'package:gestion_projects/views/admin/pages/type_users/add_type_user.dart';
import 'package:gestion_projects/views/admin/pages/type_users/type_users_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class TypeUsersView extends StatefulWidget {
  const TypeUsersView({super.key});

  @override
  State<TypeUsersView> createState() => _TypeUsersViewState();
}

class _TypeUsersViewState extends State<TypeUsersView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    super.initState();
    callAllTypeUsers();
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
    final size = MediaQuery.of(context).size;
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: true).state;
    List<TypeUserModel> listTypeUser = typeUserBloc.listTypeUser;
    if (searchState) {
      listTypeUser = typeUserBloc.listTypeUser
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = TypeUsersDataSource(
      listTypeUser,
      (typeUser) => showEdittypeUser(context, typeUser),
      (typeUser, state) => deleteTypeUser(typeUser, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Tipos de usuario'),
              SearchWidget(
                controllerText: searchCtrl,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() => searchState = true);
                  } else {
                    setState(() => searchState = false);
                  }
                },
              ),
              ButtonComponent(text: 'Nuevo tipo de usuario', onPressed: () => showCreateTypeUser(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: typeUserBloc.ascending,
                  sortColumnIndex: typeUserBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          // typeUserBloc.add(UpdateSortColumnIndexTypeUser(index));
                        }),
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

  showCreateTypeUser(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddTypeUserForm()));
  }

  showEdittypeUser(BuildContext context, TypeUserModel typeUser) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddTypeUserForm(item: typeUser)));
  }

  deleteTypeUser(TypeUserModel typeUser, bool state) {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(typeUsers(typeUser.id), body).then((res) async {
      final typeUser = typeUserItemModelFromJson(json.encode(res.data['tipoUsuario']));
      typeUserBloc.add(UpdateItemTypeUser(typeUser));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
