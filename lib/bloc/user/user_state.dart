part of 'user_bloc.dart';

class UserState extends Equatable {
  final List<UserModel> listUser;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const UserState({
    this.listUser = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  UserState copyWith({
    List<UserModel>? listUser,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      UserState(
        listUser: listUser ?? this.listUser,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [listUser, isLoading, ascending];
}
