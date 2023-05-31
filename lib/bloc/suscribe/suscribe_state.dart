part of 'suscribe_bloc.dart';

class SuscribeState extends Equatable {
  final List<SuscribeModel> listSuscribe;
  final List<UserModel> listUser;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const SuscribeState({
    this.listSuscribe = const [],
    this.listUser = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  SuscribeState copyWith({
    List<SuscribeModel>? listSuscribe,
    List<UserModel>? listUser,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      SuscribeState(
        listSuscribe: listSuscribe ?? this.listSuscribe,
        listUser: listUser ?? this.listUser,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [
        listSuscribe,
        listUser,
        isLoading,
        ascending,
      ];
}
