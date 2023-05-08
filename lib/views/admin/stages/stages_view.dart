import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/stages/add_stage.dart';
import 'package:gestion_projects/views/admin/stages/stages_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class StagesView extends StatefulWidget {
  const StagesView({super.key});

  @override
  State<StagesView> createState() => _StagesViewState();
}

class _StagesViewState extends State<StagesView> {
  @override
  void initState() {
    super.initState();
    callAllStages();
  }

  callAllStages() async {
    CafeApi.configureDio();
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    return CafeApi.httpGet(stages(null)).then((res) async {
      final stage = listStageModelFromJson(json.encode(res.data['etapas']));
      stageBloc.add(UpdateListStage(stage));
    });
  }

  @override
  Widget build(BuildContext context) {
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: true);

    final usersDataSource = StagesDataSource(
      stageBloc.state.listStage,
      (requirement) => showEditRequirement(context, requirement),
      (requirement, state) => deleteRequirement(requirement, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Etapas'),
              ButtonComponent(text: 'Nueva etapa', onPressed: () => showCreateRequirement(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: stageBloc.state.ascending,
                  sortColumnIndex: stageBloc.state.sortColumnIndex,
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

  showCreateRequirement(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) => const DialogWidget(component: AddStage()));
  }

  showEditRequirement(BuildContext context, StageModel element) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddStage(item: element)));
  }

  deleteRequirement(StageModel element, bool state) {
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
