import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/models/permision.model.dart';
import 'package:gestion_projects/views/admin/permisions/permisions_datasource.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

class PermisionsView extends StatefulWidget {
  const PermisionsView({super.key});

  @override
  State<PermisionsView> createState() => _PermisionsViewState();
}

class _PermisionsViewState extends State<PermisionsView> {
  @override
  void initState() {
    super.initState();
    callAllPermisions();
  }

  callAllPermisions() async {
    final permisionBloc = BlocProvider.of<PermisionBloc>(context, listen: false);
    debugPrint('obteniendo todos los permisos');
    CafeApi.configureDio();
    return CafeApi.httpGet(permisions()).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['permisos'])}');
      permisionBloc.add(UpdateListPermision(permisionsModelFromJson(json.encode(res.data['permisos']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final permisionBloc = BlocProvider.of<PermisionBloc>(context, listen: true);

    final usersDataSource = PermisionsDataSource(permisionBloc.state.listPermision);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          const Text('Lista de Permisos'),
          const SizedBox(height: 10),
          PaginatedDataTable(
            sortAscending: permisionBloc.state.ascending,
            sortColumnIndex: permisionBloc.state.sortColumnIndex,
            columns: [
              const DataColumn(label: Text('UID')),
              DataColumn(label: const Text('Nombre'), onSort: (colIndex, _) {}),
              DataColumn(label: const Text('Categoría'), onSort: (colIndex, _) {}),
            ],
            source: usersDataSource,
            onPageChanged: (page) {
              debugPrint('page: $page');
            },
          )
        ],
      ),
    );
  }
}
