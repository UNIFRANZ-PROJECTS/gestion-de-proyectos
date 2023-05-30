import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/pages/stages/add_stage.dart';
import 'package:gestion_projects/views/admin/pages/stages/stages_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class StagesView extends StatefulWidget {
  const StagesView({super.key});

  @override
  State<StagesView> createState() => _StagesViewState();
}

class _StagesViewState extends State<StagesView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllStages();
    callAllRequirements();
    super.initState();
  }

  callAllStages() async {
    CafeApi.configureDio();
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    return CafeApi.httpGet(stages(null)).then((res) async {
      final stage = listStageModelFromJson(json.encode(res.data['etapas']));
      stageBloc.add(UpdateListStage(stage));
    });
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
    final size = MediaQuery.of(context).size;
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: true).state;
    List<StageModel> listStage = stageBloc.listStage;
    if (searchState) {
      listStage = stageBloc.listStage
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = StagesDataSource(
      listStage,
      (requirement) => showEditRequirement(context, requirement),
      (requirement, state) => removeStages(requirement, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Etapas'),
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
              ButtonComponent(text: 'Nueva etapa', onPressed: () => showCreateRequirement(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: stageBloc.ascending,
                  sortColumnIndex: stageBloc.sortColumnIndex,
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

  removeStages(StageModel element, bool state) {
    final stageBloc = BlocProvider.of<StageBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(stages(element.id), body).then((res) async {
      final element = stageModelFromJson(json.encode(res.data['etapa']));
      stageBloc.add(UpdateItemStage(element));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
