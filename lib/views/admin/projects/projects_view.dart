import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:gestion_projects/views/admin/projects/add_project.dart';
import 'package:gestion_projects/views/admin/projects/projects_datasource.dart';

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
      (teacher) => showEditCategory(context, teacher),
      (teacher, state) => removeCategory(teacher, state),
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
            const DialogWidget(component: AddProjectForm(titleheader: 'Nueva Categoria')));
  }

  showEditCategory(BuildContext context, ProjectModel project) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddProjectForm(item: project, titleheader: project.name)));
  }

  removeCategory(ProjectModel project, bool state) {
    // final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    // CafeApi.configureDio();
    // FormData formData = FormData.fromMap({
    //   'state': state,
    // });
    // return CafeApi.put(deleteCategories(project.id), formData).then((res) async {
    //   final categoryEdit = categoryItemModelFromJson(json.encode(res.data['categoria']));
    //   categoryBloc.add(UpdateItemCategory(categoryEdit));
    // }).catchError((e) {
    //   debugPrint('e $e');
    //   debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
    //   callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    // });
  }
}
