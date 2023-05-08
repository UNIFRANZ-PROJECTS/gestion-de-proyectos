import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:gestion_projects/views/admin/projects/add_project.dart';
import 'package:gestion_projects/views/admin/projects/projects_datasource.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  void initState() {
    callAllProjects();
    super.initState();
  }

  callAllProjects() async {
    debugPrint('obteniendo todos los proyectos');
    CafeApi.configureDio();
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    return CafeApi.httpGet(projects(null)).then((res) async {
      final projects = listProjectModelFromJson(json.encode(res.data['project']));
      projectBloc.add(UpdateListProject(projects));
    });
  }

  @override
  Widget build(BuildContext context) {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: true);

    final categoriesDataSource = ProjectDataSource(
      projectBloc.state.listProject,
      (project) => showEditCategory(context, project),
      (project, state) => removeCategory(project, state),
      (project) => showSubjects(context, project),
      (project) => showStudents(context, project),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Proyectos'),
              ButtonComponent(text: 'Crear nuevo proyecto', onPressed: () => showAddTeacher(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: projectBloc.state.ascending,
                  sortColumnIndex: projectBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Categoria'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Tipo de proyecto'),
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

  showSubjects(BuildContext context, ProjectModel project) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Materias',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  project.subjectIDs.length,
                  (index) => ListTile(
                        title: Text(project.subjectIDs[index].name),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  showStudents(BuildContext context, ProjectModel project) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Estudiantes',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  project.studentIds.length,
                  (index) => ListTile(
                        title: Text(
                            '${project.studentIds[index].name} ${project.studentIds[index].lastName} ${project.studentIds[index].code}'),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  void showAddTeacher(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const DialogWidget(component: AddProjectForm(titleheader: 'Nueva Categoria')));
  }

  showEditCategory(BuildContext context, ProjectModel project) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddProjectForm(item: project, titleheader: project.name)));
  }

  removeCategory(ProjectModel project, bool state) {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(projects(project.id), formData).then((res) async {
      final project = projectModelFromJson(json.encode(res.data['project']));
      projectBloc.add(UpdateItemProject(project));
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
