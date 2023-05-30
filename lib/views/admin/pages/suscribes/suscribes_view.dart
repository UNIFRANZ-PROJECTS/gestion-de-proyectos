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

class SuscribesView extends StatefulWidget {
  const SuscribesView({super.key});

  @override
  State<SuscribesView> createState() => _SuscribesViewState();
}

class _SuscribesViewState extends State<SuscribesView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    super.initState();
    callAllSuscribes();
  }

  callAllSuscribes() async {
    final suscribeBloc = BlocProvider.of<SuscribeBloc>(context, listen: false);
    CafeApi.configureDio();
    return CafeApi.httpGet(suscribeStudent(null)).then((res) async {
      suscribeBloc.add(UpdateListSuscribe(listSuscribeModelFromJson(json.encode(res.data['suscribes']))));
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
              ButtonComponent(text: 'Inscribir', onPressed: () => showCreateSuscribe(context)),
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
                    const DataColumn(label: Text('Responsable')),
                    const DataColumn(label: Text('Fecha')),
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
  // dialogInscription(UserModel user) {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) => DialogOneFunction(
  //             title: 'Inscripción',
  //             message: !user.inscripcion
  //                 ? '¿Desea inscribir al estudiante ${user.code}?'
  //                 : '¿Desea eliminar la inscripción del estudiante${user.code}?',
  //             textButton: 'Inscribir',
  //             onPressed: () => !user.inscripcion ? suscribe(user) : unsuscribe(user),
  //           ));
  // }

  // suscribe(UserModel user) {
  //   final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
  //   final seasonBloc = BlocProvider.of<SeasonBloc>(context, listen: false).state.listSeason.firstWhere((e) => e.state);
  //   CafeApi.configureDio();
  //   FocusScope.of(context).unfocus();
  //   final Map<String, dynamic> body = {
  //     'season': seasonBloc.id,
  //     'student': user.id,
  //   };
  //   return CafeApi.post(suscribeStudent(null), body).then((res) async {
  //     final user = userModelFromJson(json.encode(res.data['student']));
  //     userBloc.add(UpdateItemUser(user));
  //     debugPrint(' ressssss ${json.encode(res.data['document'])}');
  //     final bytes = base64Decode(res.data['document']);
  //     await Printing.sharePdf(bytes: bytes, filename: 'documento.pdf');
  //     Navigator.pop(context);
  //   }).catchError((e) {
  //     debugPrint('e $e');
  //     debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
  //     callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
  //   });
  // }
  printDocument(BuildContext context, SuscribeModel suscribe) {}
  showCreateSuscribe(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddSuscribeForm()));
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
