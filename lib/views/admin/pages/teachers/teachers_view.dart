import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

import 'add_teacher.dart';
import 'teaachers_datasource.dart';

class TeacherView extends StatefulWidget {
  const TeacherView({super.key});

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllTeachers();
    super.initState();
  }

  callAllTeachers() async {
    debugPrint('obteniendo todos los docentes');
    CafeApi.configureDio();
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    return CafeApi.httpGet(teachers(null)).then((res) async {
      debugPrint(json.encode(res.data['teacher']));
      final teachers = listTeacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateListTeacher(teachers));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: true).state;
    List<TeacherModel> listTeacher = teacherBloc.listTeacher;
    if (searchState) {
      listTeacher = teacherBloc.listTeacher
          .where((e) => '${e.name} ${e.lastName}'.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final teachersDataSource = TeachersDataSource(
      listTeacher,
      (teacher) => showEditTeacher(context, teacher),
      (teacher, state) => removeTeacher(teacher, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Docentes'),
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
              ButtonComponent(text: 'Nuevo Docente', onPressed: () => showAddTeacher(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: teacherBloc.ascending,
                  sortColumnIndex: teacherBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Apellido'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Carnet'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Correo'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: teachersDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  void showAddTeacher(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(component: AddTeacherForm(titleheader: 'Nuevo Docente')));
  }

  showEditTeacher(BuildContext context, TeacherModel teacher) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddTeacherForm(item: teacher, titleheader: teacher.name)));
  }

  removeTeacher(TeacherModel teacher, bool state) {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(teachers(teacher.id), body).then((res) async {
      final categoryEdit = teacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateItemTeacher(categoryEdit));
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
