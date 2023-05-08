import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/permision.model.dart';
import 'package:gestion_projects/models/role.model.dart';
import 'package:gestion_projects/views/admin/roles/add_rol.dart';
import 'package:gestion_projects/views/admin/roles/roles_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class RolesView extends StatefulWidget {
  const RolesView({super.key});

  @override
  State<RolesView> createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  @override
  void initState() {
    super.initState();
    callAllRoles();
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

  @override
  Widget build(BuildContext context) {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: true);

    final usersDataSource = RolesDataSource(
      rolBloc.state.listRoles,
      (typeUser) => showEditRol(context, typeUser),
      (typeUser, state) => removeRol(typeUser, state),
      (permisions) => showPermisions(context, permisions),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Roles'),
              ButtonComponent(text: 'Agregar nuevo Rol', onPressed: () => showCreateRol(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: rolBloc.state.ascending,
                  sortColumnIndex: rolBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          rolBloc.add(UpdateSortColumnIndexRol(index));
                        }),
                    const DataColumn(label: Text('Permisos')),
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

  showCreateRol(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) => const DialogWidget(component: AddRolForm()));
  }

  showEditRol(BuildContext context, RolesModel rol) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddRolForm(item: rol)));
  }

  removeRol(RolesModel rol, bool state) {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    CafeApi.configureDio();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    debugPrint('formData ${formData.fields}');
    return CafeApi.put(roles(rol.id), formData).then((res) async {
      debugPrint(json.encode(res.data['rol']));
      rolBloc.add(UpdateItemRol(rolItemModelFromJson(json.encode(res.data['rol']))));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  showPermisions(BuildContext context, List<PermisionsModel> permisionIds) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Permisos',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  permisionIds.length,
                  (index) => ListTile(
                        title: Text(permisionIds[index].name),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
