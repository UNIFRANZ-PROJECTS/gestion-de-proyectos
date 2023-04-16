import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
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
  @override
  void initState() {
    callAllTeachers();
    super.initState();
  }

  callAllTeachers() async {
    debugPrint('obteniendo todos los docentes');
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    return CafeApi.httpGet(teachers(null)).then((res) async {
      final teachers = listTeacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateListTeacher(teachers));
    });
  }

  @override
  Widget build(BuildContext context) {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: true);

    final categoriesDataSource = TeachersDataSource(
      teacherBloc.state.listTeacher,
      (teacher) => showEditCategory(context, teacher),
      (teacher, state) => removeCategory(teacher, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Docentes'),
              ButtonComponent(text: 'Agregar nuevo Docente', onPressed: () => showAddTeacher(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: teacherBloc.state.ascending,
                  sortColumnIndex: teacherBloc.state.sortColumnIndex,
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
                        label: const Text('Especialidad'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Descripcion'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: categoriesDataSource,
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
        builder: (BuildContext context) =>
            const DialogWidget(component: AddTeacherForm(titleheader: 'Nueva Categoria')));
  }

  showEditCategory(BuildContext context, TeacherModel teacher) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddTeacherForm(item: teacher, titleheader: teacher.name)));
  }

  removeCategory(TeacherModel teacher, bool state) {
    final teacherBloc = BlocProvider.of<TeacherBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(teachers(teacher.id), formData).then((res) async {
      final categoryEdit = teacherModelFromJson(json.encode(res.data['teacher']));
      teacherBloc.add(UpdateItemTeacher(categoryEdit));
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
