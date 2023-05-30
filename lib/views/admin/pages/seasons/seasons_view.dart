import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/views/admin/pages/seasons/add_season.dart';
import 'package:gestion_projects/views/admin/pages/seasons/seasons_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SeasonsView extends StatefulWidget {
  const SeasonsView({super.key});

  @override
  State<SeasonsView> createState() => _SeasonsViewState();
}

class _SeasonsViewState extends State<SeasonsView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllSeasons();
    callAllStages();
    super.initState();
  }

  callAllSeasons() async {
    CafeApi.configureDio();
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    return CafeApi.httpGet(seasons(null)).then((res) async {
      debugPrint('RESP ${json.encode(res.data['temporadas'])}');
      final season = listSeasonModelFromJson(json.encode(res.data['temporadas']));
      debugPrint('length ${season.length}');
      seasonBloc.add(UpdateListSeason(season));
    });
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
    final size = MediaQuery.of(context).size;
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: true);
    List<SeasonModel> listSeason = seasonBloc.state.listSeason;
    if (searchState) {
      listSeason = seasonBloc.state.listSeason
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final usersDataSource = SeasonsDataSource(listSeason, (season) => showEditSeason(context, season),
        (season, state) => deleteSeason(season, state), (stages) => showStages(context, stages));
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Temporadas'),
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
                    const DataColumn(label: Text('Inicio')),
                    const DataColumn(label: Text('Fin')),
                    const DataColumn(label: Text('Precio')),
                    const DataColumn(label: Text('Etapas')),
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

  showStages(BuildContext context, List<StageModel> stages) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Etapas',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  stages.length,
                  (index) => ListTile(
                        title: Text(stages[index].name),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  showCreateSeason(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) => const DialogWidget(component: AddSeason()));
  }

  showEditSeason(BuildContext context, SeasonModel element) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddSeason(item: element)));
  }

  deleteSeason(SeasonModel element, bool state) {
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(seasonEnable(element.id), body).then((res) async {
      final season = listSeasonModelFromJson(json.encode(res.data['temporadas']));
      seasonBloc.add(UpdateListSeason(season));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
