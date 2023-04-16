import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projects/models/type_user.model.dart';

part 'type_user_event.dart';
part 'type_user_state.dart';

class TypeUserBloc extends Bloc<TypeUserEvent, TypeUserState> {
  List<TypeUserModel> listTypeUser = [];
  TypeUserBloc() : super(const TypeUserState()) {
    on<UpdateListTypeUser>((event, emit) => emit(state.copyWith(listTypeUser: event.listTypeUser)));
    on<UpdateSortColumnIndexTypeUser>((event, emit) {
      sort((event) => event.name);
      emit(state.copyWith(
          listTypeUser: listTypeUser, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemTypeUser>((event, emit) {
      emit(state.copyWith(listTypeUser: [...state.listTypeUser, event.typeUser]));
    });
    on<UpdateItemTypeUser>(((event, emit) => _onUpdateTypeUserById(event, emit)));
  }
  void sort<T>(Comparable<T> Function(TypeUserModel event) getField) {
    listTypeUser = [...state.listTypeUser];
    listTypeUser.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateTypeUserById(UpdateItemTypeUser typeUser, Emitter<TypeUserState> emit) async {
    List<TypeUserModel> listNewTypeUser = [...state.listTypeUser];
    debugPrint('hola');
    listNewTypeUser[listNewTypeUser.indexWhere((e) => e.id == typeUser.typeUser.id)] = typeUser.typeUser;
    emit(state.copyWith(listTypeUser: listNewTypeUser));
  }
}
