import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/seasons/add_season.dart';
import 'package:gestion_projects/views/admin/seasons/seasons_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class SeasonsView extends StatefulWidget {
  const SeasonsView({super.key});

  @override
  State<SeasonsView> createState() => _SeasonsViewState();
}

class _SeasonsViewState extends State<SeasonsView> {
  @override
  void initState() {
    callAllSeasons();
    super.initState();
  }

  callAllSeasons() async {
    CafeApi.configureDio();
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    return CafeApi.httpGet(seasons(null)).then((res) async {
      debugPrint('${json.encode(res.data['temporadas'])}');
      final requirement = listSeasonModelFromJson(json.encode(res.data['temporadas']));
      seasonBloc.add(UpdateListSeason(requirement));
    });
  }

  @override
  Widget build(BuildContext context) {
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: true);

    final usersDataSource = SeasonsDataSource(
      seasonBloc.state.listSeason,
      (season) => showEditSeason(context, season),
      (season, state) => deleteSeason(season, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de temporadas'),
              ButtonComponent(text: 'Nueva temporada', onPressed: () => showCreateSeason(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: seasonBloc.state.ascending,
                  sortColumnIndex: seasonBloc.state.sortColumnIndex,
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

  showCreateSeason(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) => const DialogWidget(component: AddSeason()));
  }

  showEditSeason(BuildContext context, SeasonModel element) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddSeason(item: element)));
  }

  deleteSeason(SeasonModel element, bool state) {
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
