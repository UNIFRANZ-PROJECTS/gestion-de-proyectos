import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/pages/requirements/add_requirement.dart';
import 'package:gestion_projects/views/admin/pages/requirements/requirements_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class RequirementsView extends StatefulWidget {
  const RequirementsView({super.key});

  @override
  State<RequirementsView> createState() => _RequirementsViewState();
}

class _RequirementsViewState extends State<RequirementsView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
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
    final size = MediaQuery.of(context).size;
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: true).state;
    List<RequirementModel> listRequirement = requirementBloc.listRequirement;
    if (searchState) {
      listRequirement = requirementBloc.listRequirement
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = RequirementsDataSource(
      listRequirement,
      (requirement) => showEditRequirement(context, requirement),
      (requirement, state) => deleteRequirement(requirement, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Requerimientos'),
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
              ButtonComponent(text: 'Nuevo requisito', onPressed: () => showCreateRequirement(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: requirementBloc.ascending,
                  sortColumnIndex: requirementBloc.sortColumnIndex,
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
    final requirementBloc = BlocProvider.of<RequirementBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(requirements(element.id), body).then((res) async {
      final element = requirementModelFromJson(json.encode(res.data['requisito']));
      requirementBloc.add(UpdateItemRequirement(element));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
