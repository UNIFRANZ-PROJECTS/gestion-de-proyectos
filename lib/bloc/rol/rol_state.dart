part of 'rol_bloc.dart';

class RolState extends Equatable {
  final List<RolesModel> listRoles;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const RolState({
    this.listRoles = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  RolState copyWith({
    List<RolesModel>? listRoles,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      RolState(
        listRoles: listRoles ?? this.listRoles,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listRoles, isLoading, ascending];
}
