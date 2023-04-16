import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/permision.model.dart';

part 'permision_event.dart';
part 'permision_state.dart';

class PermisionBloc extends Bloc<PermisionEvent, PermisionState> {
  List<PermisionsModel> listPermision = [];
  PermisionBloc() : super(const PermisionState()) {
    on<UpdateListPermision>((event, emit) => emit(state.copyWith(listPermision: event.listPermision)));
    on<UpdateSortColumnIndexPermision>((event, emit) {
      sort((event) => event.name);
      emit(state.copyWith(
          listPermision: listPermision, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
  }

  void sort<T>(Comparable<T> Function(PermisionsModel event) getField) {
    listPermision = [...state.listPermision];
    listPermision.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }
}
