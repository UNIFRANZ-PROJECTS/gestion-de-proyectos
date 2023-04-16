import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

import 'add_subject.dart';
import 'subjects_datasource.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  @override
  void initState() {
    callAllSubjects();
    super.initState();
  }

  callAllSubjects() async {
    debugPrint('obteniendo todos las materias');
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    return CafeApi.httpGet(subjects(null)).then((res) async {
      final subjects = listSubjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateListSubject(subjects));
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: true);

    final categoriesDataSource = TeachersDataSource(
      subjectBloc.state.listSubject,
      (teacher) => showEditCategory(context, teacher),
      (teacher, state) => removeCategory(teacher, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Materias'),
              ButtonComponent(text: 'Agregar nueva materia', onPressed: () => showAddTeacher(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: subjectBloc.state.ascending,
                  sortColumnIndex: subjectBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Semestre'),
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

  showEditCategory(BuildContext context, SubjectModel subject) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddTeacherForm(item: subject, titleheader: subject.name)));
  }

  removeCategory(SubjectModel subject, bool state) {
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(subjects(subject.id), formData).then((res) async {
      final categoryEdit = subjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateItemSubject(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
