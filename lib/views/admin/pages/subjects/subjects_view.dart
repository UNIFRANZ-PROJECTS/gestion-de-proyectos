import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:gestion_projects/views/admin/pages/subjects/add_info_subjects.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'add_subject.dart';
import 'subjects_datasource.dart';

class SubjectView extends StatefulWidget {
  const SubjectView({super.key});

  @override
  State<SubjectView> createState() => _SubjectViewState();
}

class _SubjectViewState extends State<SubjectView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllSubjects();
    super.initState();
  }

  callAllSubjects() async {
    debugPrint('obteniendo todos las materias');
    CafeApi.configureDio();
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: false);
    return CafeApi.httpGet(subjects(null)).then((res) async {
      final subjects = listSubjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateListSubject(subjects));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final subjectBloc = BlocProvider.of<SubjectBloc>(context, listen: true);
    List<SubjectModel> listSubject = subjectBloc.state.listSubject;
    if (searchState) {
      listSubject = subjectBloc.state.listSubject
          .where((e) =>
              '${e.code}${e.name}${e.semester}'.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final categoriesDataSource = TeachersDataSource(
      listSubject,
      (subject) => showEditCategory(context, subject),
      (subject, state) => removeCategory(subject, state),
      (subject) {},
      // (subject) => showTeachers(context, subject.teacherIds),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Materias'),
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
              ButtonComponent(text: 'Subir excel', onPressed: () => uploadxlxs(context)),
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
                        label: const Text('Codigo'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
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

  showTeachers(BuildContext context, List<TeacherModel> teachers) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Docentes',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  teachers.length,
                  (index) => ListTile(
                        title: Text(teachers[index].name),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  void uploadxlxs(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(
              component: AddSubjectsData(),
            ));
  }

  void showAddTeacher(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(component: AddTeacherForm(titleheader: 'Nueva Materia')));
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
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(subjects(subject.id), body).then((res) async {
      final categoryEdit = subjectModelFromJson(json.encode(res.data['subject']));
      subjectBloc.add(UpdateItemSubject(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
