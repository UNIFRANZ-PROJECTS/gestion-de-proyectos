import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';

import 'add_parallel.dart';
import 'parallels_datasource.dart';

class ParallelsView extends StatefulWidget {
  const ParallelsView({super.key});

  @override
  State<ParallelsView> createState() => _ParallelsViewState();
}

class _ParallelsViewState extends State<ParallelsView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllParallels();
    callAllTeachers();
    callAllSubjects();
    super.initState();
  }

  callAllParallels() async {
    debugPrint('obteniendo todos los paralelos');
    CafeApi.configureDio();
    final parallelBloc = BlocProvider.of<ParallelBloc>(context, listen: false);
    return CafeApi.httpGet(parallels(null)).then((res) async {
      debugPrint(json.encode(res.data['paralelos']));
      final parallels = listParallelModelFromJson(json.encode(res.data['paralelos']));
      parallelBloc.add(UpdateListParallel(parallels));
    });
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
    final parallelBloc = BlocProvider.of<ParallelBloc>(context, listen: true).state;
    List<ParallelModel> listParallel = parallelBloc.listParallel;
    if (searchState) {
      listParallel = parallelBloc.listParallel
          .where((e) => e.teacherId.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final categoriesDataSource = ParallelsDataSource(
      listParallel,
      (parallel) => showEditParallel(context, parallel),
      (parallel, state) => removeParallel(parallel, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Paralelos'),
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
              ButtonComponent(text: 'Nuevo Paralelo', onPressed: () => showAddParallel(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: parallelBloc.ascending,
                  sortColumnIndex: parallelBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Paralelo'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Materia'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Docente'),
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

  void showAddParallel(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const DialogWidget(component: AddParallelForm(titleheader: 'Nuevo Paralelo')));
  }

  showEditParallel(BuildContext context, ParallelModel parallel) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddParallelForm(item: parallel, titleheader: parallel.subjectId.name)));
  }

  removeParallel(ParallelModel parallel, bool state) {
    final parallelBloc = BlocProvider.of<ParallelBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(parallels(parallel.id), body).then((res) async {
      final paralelo = parallelModelFromJson(json.encode(res.data['paralelo']));
      parallelBloc.add(UpdateItemParallel(paralelo));
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
