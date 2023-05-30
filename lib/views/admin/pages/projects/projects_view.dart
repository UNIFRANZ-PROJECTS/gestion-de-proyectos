import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';
import 'package:gestion_projects/services/local_storage.dart';
import 'package:gestion_projects/views/admin/pages/projects/projects_view_admin.dart';
import 'package:gestion_projects/views/admin/pages/projects/projects_view_student.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    final authData = authModelFromJson(LocalStorage.prefs.getString('userData')!);
    return authData.rol.name != 'Estudiante' ? const ViewProjectsByAdmin() : const ViewProjectsByStudent();
  }
}
