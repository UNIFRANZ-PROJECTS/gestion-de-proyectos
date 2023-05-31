import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/models/type_user.model.dart';
import 'package:gestion_projects/views/admin/pages/suscribes/add_suscribe.dart';
import 'package:gestion_projects/views/admin/pages/suscribes/suscribes_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:printing/printing.dart';

class SuscribesView extends StatefulWidget {
  const SuscribesView({super.key});

  @override
  State<SuscribesView> createState() => _SuscribesViewState();
}

class _SuscribesViewState extends State<SuscribesView> {
  TextEditingController searchCtrl = TextEditingController();
  bool stateLoading = false;
  bool searchState = false;
  double? price;
  String hintTextDate = 'Rango de fechas del evento';
  DateTime? startDate;
  DateTime? endDate;
  @override
  void initState() {
    callAllSeasons();
    callAllSuscribes();
    callAllUsersDebt();
    super.initState();
  }

  callAllSeasons() async {
    CafeApi.configureDio();
    final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false);
    return CafeApi.httpGet(seasons(null)).then((res) async {
      debugPrint('todas las temporadas ${json.encode(res.data['temporadas'])}');
      final season = listSeasonModelFromJson(json.encode(res.data['temporadas']));
      debugPrint('length ${season.length}');
      seasonBloc.add(UpdateListSeason(season));
    });
  }

  callAllSuscribes() async {
    debugPrint('TODAS LAS INSCRIPCIONES');
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: false);
    CafeApi.configureDio();
    return CafeApi.httpGet(suscribeStudent(null)).then((res) async {
      debugPrint('todas las inscripciones ${res.data['season']}');
      setState(() => price = res.data['season']['price']);
      suscribeBloc.add(UpdateListSuscribe(listSuscribeModelFromJson(json.encode(res.data['suscribes']))));
    });
  }

  callAllUsersDebt() async {
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: false);
    CafeApi.configureDio();
    return CafeApi.httpGet(suscribeStudentsDebt()).then((res) async {
      suscribeBloc.add(UpdateListStudentsDebt(listUserModelFromJson(json.encode(res.data['students']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: true).state;
    List<SuscribeModel> listSuscribe = suscribeBloc.listSuscribe;
    if (searchState) {
      listSuscribe = suscribeBloc.listSuscribe
          .where((e) => e.student.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = SuscribesDataSource(
      listSuscribe,
      (suscribe) => printDocument(context, suscribe),
      (suscribe, state) => deleteSuscribe(suscribe, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Inscripciones'),
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
              if (price != null) ButtonComponent(text: 'Inscribir', onPressed: () => showCreateSuscribe(context)),
            ],
          ),
          if (price != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DateTimeWidget(
                    labelText: 'Fechas:',
                    hintText: hintTextDate,
                    selectDate: (value1, value2) {
                      setState(() {
                        startDate = DateTime.parse(value1);
                        endDate = DateTime.parse(value2);
                        hintTextDate = value1 == value2 ? value1 : '$value1 - $value2';
                      });
                      return showFilter(context);
                    }),
                ButtonComponent(text: 'Descargar xlxs', onPressed: () => downloadReport(context)),
              ],
            ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: suscribeBloc.ascending,
                  sortColumnIndex: suscribeBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Estudiante'),
                        onSort: (index, _) {
                          // suscribeBloc.add(UpdateSortColumnIndexTypeUser(index));
                        }),
                    const DataColumn(label: Text('Código')),
                    const DataColumn(label: Text('Responsable')),
                    const DataColumn(label: Text('Fecha')),
                    const DataColumn(label: Text('Monto')),
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

  showFilter(BuildContext context) {
    // setState(() => stateLoading = !stateLoading);
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: false);
    debugPrint('obteniendo toda la info para reportes');
    CafeApi.configureDio();
    final Map<String, dynamic> body = {
      'start': '$startDate',
      'end': '$endDate',
    };
    return CafeApi.post(suscribeFilter(), body).then((res) async {
      // setState(() => stateLoading = !stateLoading);
      debugPrint('todas las inscripciones ${res.data}');
      suscribeBloc.add(UpdateListSuscribe(listSuscribeModelFromJson(json.encode(res.data['suscribes']))));
    }).catchError((err) {
      debugPrint(err);
      setState(() => stateLoading = !stateLoading);
    });
  }

  downloadReport(BuildContext context) {
    debugPrint('obteniendo toda la info para dashboar');
    CafeApi.configureDio();
    final Map<String, dynamic> body = {
      'start': '$startDate',
      'end': '$endDate',
    };
    return CafeApi.post(reportsSuscribeDownload(), body).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['base64'])}');
      final bytes = base64Decode(res.data['base64']);
      await Printing.sharePdf(bytes: bytes, filename: 'reporte.xlsx');
    });
  }

  printDocument(BuildContext context, SuscribeModel suscribe) {
    CafeApi.configureDio();
    return CafeApi.httpGet(suscribeById(suscribe.id)).then((res) async {
      debugPrint(' ressssss ${res.data}');
      final bytes = base64Decode(res.data['document']);
      await Printing.sharePdf(bytes: bytes, filename: 'documento.pdf');
    });
  }

  showCreateSuscribe(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddSuscribeForm(price: price!)));
  }

  deleteSuscribe(SuscribeModel suscribe, bool state) {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(suscribeStudent(suscribe.id), body).then((res) async {
      final typeUser = typeUserItemModelFromJson(json.encode(res.data['tipoUsuario']));
      typeUserBloc.add(UpdateItemTypeUser(typeUser));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
