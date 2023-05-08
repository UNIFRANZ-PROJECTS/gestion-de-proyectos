import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/requirements/add_requirement.dart';
import 'package:gestion_projects/views/admin/requirements/requirements_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class RequirementsView extends StatefulWidget {
  const RequirementsView({super.key});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  @override
  void initState() {
    super.initState();
    callAllRequirements();
  }

  callAllRequirements() async {
    CafeApi.configureDio();
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: false);
    return CafeApi.httpGet(requirements(null)).then((res) async {
      final requirement = listRequirementModelFromJson(json.encode(res.data['requisitos']));
      requirementBloc.add(UpdateListRequirement(requirement));
    });
  }

  @override
  Widget build(BuildContext context) {
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: true);

    final usersDataSource = RequirementsDataSource(
      requirementBloc.state.listRequirement,
      (requirement) => showEditRequirement(context, requirement),
      (requirement, state) => deleteRequirement(requirement, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Requerimientos'),
              ButtonComponent(text: 'Nuevo requisito', onPressed: () => showCreateRequirement(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: requirementBloc.state.ascending,
                  sortColumnIndex: requirementBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          // typeUserBloc.add(UpdateSortColumnIndexTypeUser(index));
                        }),
                    const DataColumn(label: Text('Descripcion')),
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

  showCreateRequirement(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddRequirement()));
  }

  showEditRequirement(BuildContext context, RequirementModel element) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddRequirement(item: element)));
  }

  deleteRequirement(RequirementModel element, bool state) {
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
