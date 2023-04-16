part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class UpdateListProject extends ProjectEvent {
  final List<ProjectModel> listProject;

  const UpdateListProject(this.listProject);
}
