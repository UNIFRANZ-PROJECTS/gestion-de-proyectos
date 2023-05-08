part of 'type_project_bloc.dart';

class TypeProjectState extends Equatable {
  final List<ElementModel> listTypeProject;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const TypeProjectState({
    this.listTypeProject = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  TypeProjectState copyWith({
    List<ElementModel>? listTypeProject,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      TypeProjectState(
        listTypeProject: listTypeProject ?? this.listTypeProject,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );

  @override
  List<Object> get props => [listTypeProject, isLoading, ascending];
}
