import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/type_projects/add_type_project.dart';
import 'package:gestion_projects/views/admin/type_projects/type_projects_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class TypeProjectsView extends StatefulWidget {
  const TypeProjectsView({super.key});

  @override
  State<TypeProjectsView> createState() => _TypeProjectsViewState();
}

class _TypeProjectsViewState extends State<TypeProjectsView> {
  @override
  void initState() {
    super.initState();
    callAllTypeProjects();
  }

  callAllTypeProjects() async {
    debugPrint('obteniendo todos los tipos de proyectos');
    CafeApi.configureDio();
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: false);
    return CafeApi.httpGet(typeProjects(null)).then((res) async {
      final elements = listElementModelFromJson(json.encode(res.data['tiposProyectos']));
      typeProjectBloc.add(UpdateListTypeProject(elements));
    });
  }

  @override
  Widget build(BuildContext context) {
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: true);

    final usersDataSource = TypeProjectsDataSource(
      typeProjectBloc.state.listTypeProject,
      (typeUser) => showEdittypeUser(context, typeUser),
      (typeUser, state) => deleteTypeUser(typeUser, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Categorias'),
              ButtonComponent(text: 'Nueva categoria', onPressed: () => showCreateTypeUser(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: typeProjectBloc.state.ascending,
                  sortColumnIndex: typeProjectBloc.state.sortColumnIndex,
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
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddTypeProjectForm()));
  }

  showEdittypeUser(BuildContext context, ElementModel element) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => DialogWidget(component: AddTypeProjectForm(item: element)));
  }

  deleteTypeUser(ElementModel element, bool state) {
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(typeProjects(element.id), formData).then((res) async {
      final element = elementModelFromJson(json.encode(res.data['tipoProyecto']));
      typeProjectBloc.add(UpdateItemTypeProject(element));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
