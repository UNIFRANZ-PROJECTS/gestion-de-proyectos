import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  List<UserModel> listUser = [];
  UserBloc() : super(const UserState()) {
    on<UpdateListUser>((event, emit) => emit(state.copyWith(listUser: event.listUsers)));
    on<UpdateSortColumnIndexUser>((event, emit) {
      sort((event) => event.name);
      emit(state.copyWith(listUser: listUser, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemUser>((event, emit) {
      emit(state.copyWith(listUser: [...state.listUser, event.user]));
    });

    on<UpdateItemUser>(((event, emit) => _onUpdateTypeUserById(event, emit)));
  }
  void sort<T>(Comparable<T> Function(UserModel event) getField) {
    listUser = [...state.listUser];
    listUser.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateTypeUserById(UpdateItemUser user, Emitter<UserState> emit) async {
    List<UserModel> listNewUser = [...state.listUser];
    listNewUser[listNewUser.indexWhere((e) => e.id == user.user.id)] = user.user;
    emit(state.copyWith(listUser: listNewUser));
  }
}
