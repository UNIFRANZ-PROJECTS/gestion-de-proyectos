import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/role.model.dart';

part 'rol_event.dart';
part 'rol_state.dart';

class RolBloc extends Bloc<RolEvent, RolState> {
  List<RolesModel> listRol = [];
  RolBloc() : super(const RolState()) {
    on<UpdateListRol>((event, emit) => emit(state.copyWith(listRoles: event.listRol)));
    on<UpdateSortColumnIndexRol>((event, emit) {
      sort((event) => event.name);
      emit(state.copyWith(listRoles: listRol, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemRol>((event, emit) {
      emit(state.copyWith(listRoles: [...state.listRoles, event.rol]));
    });
    on<UpdateItemRol>(((event, emit) => _onUpdateRolById(event, emit)));
  }

  void sort<T>(Comparable<T> Function(RolesModel event) getField) {
    listRol = [...state.listRoles];
    listRol.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateRolById(UpdateItemRol event, Emitter<RolState> emit) async {
    List<RolesModel> listNewRol = [...state.listRoles];
    listNewRol[listNewRol.indexWhere((e) => e.id == event.rol.id)] = event.rol;
    emit(state.copyWith(listRoles: listNewRol));
  }
}
