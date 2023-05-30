import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gestion_projects/bloc/project/project_bloc.dart';
import 'package:gestion_projects/components/inputs/search.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/cafe_api.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:gestion_projects/services/services.dart';
import 'package:gestion_projects/views/admin/pages/projects/card_project.dart';

class ViewProjectsByStudent extends StatefulWidget {
  const ViewProjectsByStudent({super.key});

  @override
  State<ViewProjectsByStudent> createState() => _ViewProjectsByStudentState();
}

class _ViewProjectsByStudentState extends State<ViewProjectsByStudent> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;

  @override
  void initState() {
    super.initState();
    callAllProjects();
  }

  callAllProjects() async {
    debugPrint('Obteniendo todos los proyectos');
    final authData = authModelFromJson(LocalStorage.prefs.getString('userData')!);
    CafeApi.configureDio();
    final projectBloc = BlocProvider.of<ProjectBloc>(context, listen: false);

    CafeApi.httpGet(projectsByStudent(authData.uid)).then((res) async {
      final listProjects = json.encode(res.data['projects']);
      final projects = listProjectModelFromJson(listProjects);

      debugPrint(json.encode(projects));
      projectBloc.add(UpdateListProject(projects));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchWidget(
          isWhite: true,
          controllerText: searchCtrl,
          onChanged: (value) {
            setState(() {
              if (value.trim().isNotEmpty) {
                searchState = true;
              } else {
                searchState = false;
              }
            });
          },
        ),
        Expanded(
          flex: 10,
          child: BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              final projects = _getProjects(state);
              return (size.width > 1000)
                  ? MasonryGridView.count(
                      crossAxisCount: 4,
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return itemProject(projects[index]);
                      },
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: projects.map(itemProject).toList(),
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  List<ProjectModel> _getProjects(ProjectState state) {
    final allProjects = state.listProject;
    if (searchState) {
      return allProjects
          .where((e) => e.project.title.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    return allProjects.toList();
  }

  Widget itemProject(ProjectModel project) {
    return Hero(
      tag: 'flipcardHero${project.project.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ProjectWidget(
            project: project,
          ),
        ),
      ),
    );
  }
}
