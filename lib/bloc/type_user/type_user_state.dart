part of 'type_user_bloc.dart';

class TypeUserState extends Equatable {
  final List<TypeUserModel> listTypeUser;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const TypeUserState({
    this.listTypeUser = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  TypeUserState copyWith({
    List<TypeUserModel>? listTypeUser,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      TypeUserState(
        listTypeUser: listTypeUser ?? this.listTypeUser,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listTypeUser, isLoading, ascending];
}
