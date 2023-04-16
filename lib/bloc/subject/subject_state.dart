part of 'subject_bloc.dart';

class SubjectState extends Equatable {
  final List<SubjectModel> listSubject;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const SubjectState({
    this.listSubject = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  SubjectState copyWith({
    List<SubjectModel>? listSubject,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      SubjectState(
        listSubject: listSubject ?? this.listSubject,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listSubject, isLoading, ascending];
}
