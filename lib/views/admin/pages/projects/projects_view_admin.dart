import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestion_projects/bloc/blocs.dart';
import 'package:gestion_projects/components/compoents.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:gestion_projects/views/admin/pages/projects/add_project.dart';
import 'package:gestion_projects/views/admin/pages/projects/projects_datasource.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:printing/printing.dart';

class ViewProjectsByAdmin extends StatefulWidget {
  const ViewProjectsByAdmin({super.key});

  @override
  State<ViewProjectsByAdmin> createState() => _ViewProjectsByAdminState();
}

class _ViewProjectsByAdminState extends State<ViewProjectsByAdmin> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllProjects();
    callAllParallels();
    callAllUsers();
    callAllSubjects();
    callAllCategories();
    callAllTypeProjects();
    super.initState();
  }

  callAllProjects() async {
    debugPrint('obteniendo todos los proyectos');
    CafeApi.configureDio();
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    return CafeApi.httpGet(projects(null)).then((res) async {
      final listProjects = json.encode(res.data['projects']);
      final projects = listProjectModelFromJson(listProjects);

      debugPrint(json.encode(projects));
      projectBloc.add(UpdateListProject(projects));
    });
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

  callAllUsers() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    return CafeApi.httpGet(users(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['estudiantes'])}');
      userBloc.add(UpdateListUser(listUserModelFromJson(json.encode(res.data['estudiantes']))));
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

  callAllCategories() async {
    debugPrint('obteniendo todos las categorias');
    CafeApi.configureDio();
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    return CafeApi.httpGet(categories(null)).then((res) async {
      final subjects = listElementModelFromJson(json.encode(res.data['categories']));
      categoryBloc.add(UpdateListCategory(subjects));
    });
  }

  callAllTypeProjects() async {
    debugPrint('obteniendo todos los tipos de proyectos');
    CafeApi.configureDio();
    final typeProjectBloc = BlocProvider.of<TypeProjectBloc>(context, listen: false);
    return CafeApi.httpGet(typeProjects(null)).then((res) async {
      final elements = listElementModelFromJson(json.encode(res.data['tiposProyectos']));
      typeProjectBloc.add(UpdateListTypeProject(elements));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: true).state;
    List<ProjectModel> listProject = projectBloc.listProject;
    if (searchState) {
      listProject = projectBloc.listProject
          .where((e) => e.project.title.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final categoriesDataSource = ProjectDataSource(
      listProject,
      (project) => showEditCategory(context, project),
      (project, state) => removeCategory(project, state),
      (project) => showSubjects(context, project),
      (project) => showStudents(context, project),
      (project) => printDocument(context, project),
    );
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Proyectos'),
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
              ButtonComponent(text: 'Crear nuevo proyecto', onPressed: () => showAddTeacher(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: projectBloc.ascending,
                  sortColumnIndex: projectBloc.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Código'),
                        onSort: (colIndex, _) {
                          // teacherBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Titulo'),
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
                  project.materias.length,
                  (index) => ListTile(
                        title: Text(
                            '${project.materias[index].subjectId.name} - ${project.materias[index].teacherId.name} ${project.materias[index].teacherId.lastName}'),
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
                  project.project.studentIds.length,
                  (index) => ListTile(
                        title: Text(
                            '${project.project.studentIds[index].name} ${project.project.studentIds[index].lastName} ${project.project.studentIds[index].code}'),
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
            const DialogWidget(component: AddProjectForm(titleheader: 'Nuevo Proyecto')));
  }

  showEditCategory(BuildContext context, ProjectModel project) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddProjectForm(item: project, titleheader: project.project.title)));
  }

  removeCategory(ProjectModel project, bool state) {
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(projects(project.project.id), body).then((res) async {
      final project = projectModelFromJson(json.encode(res.data['project'][0]));
      projectBloc.add(UpdateItemProject(project));
    }).catchError((e) {
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  printDocument(BuildContext context, ProjectModel project) {
    debugPrint('obteniendo documento');
    CafeApi.configureDio();
    return CafeApi.httpGet(documentProject(project.project.id)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['base64'])}');
      final bytes = base64Decode(res.data['base64']);
      await Printing.sharePdf(bytes: bytes, filename: 'documento.xlsx');
    });
  }
}
