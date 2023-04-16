part of 'teacher_bloc.dart';

class TeacherState extends Equatable {
  final List<TeacherModel> listTeacher;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const TeacherState({
    this.listTeacher = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  TeacherState copyWith({
    List<TeacherModel>? listTeacher,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      TeacherState(
        listTeacher: listTeacher ?? this.listTeacher,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listTeacher, isLoading, ascending];
}
