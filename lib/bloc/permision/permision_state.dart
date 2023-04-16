part of 'permision_bloc.dart';

class PermisionState extends Equatable {
  final List<PermisionsModel> listPermision;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const PermisionState({
    this.listPermision = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  PermisionState copyWith({
    List<PermisionsModel>? listPermision,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      PermisionState(
        listPermision: listPermision ?? this.listPermision,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listPermision, isLoading, ascending];
}
