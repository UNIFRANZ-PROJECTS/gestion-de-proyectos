part of 'project_bloc.dart';

class ProjectState extends Equatable {
  final List<ProjectModel> listProject;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const ProjectState({
    this.listProject = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  ProjectState copyWith({
    List<ProjectModel>? listProject,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      ProjectState(
        listProject: listProject ?? this.listProject,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );

  @override
  List<Object> get props => [listProject, isLoading, ascending];
}
