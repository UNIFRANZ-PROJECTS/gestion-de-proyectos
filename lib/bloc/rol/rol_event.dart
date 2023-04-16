part of 'rol_bloc.dart';

abstract class RolEvent extends Equatable {
  const RolEvent();

  @override
  List<Object> get props => [];
}

class UpdateListRol extends RolEvent {
  final List<RolesModel> listRol;

  const UpdateListRol(this.listRol);
}

class UpdateSortColumnIndexRol extends RolEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexRol(this.sortColumnIndex);
}

class AddItemRol extends RolEvent {
  final RolesModel rol;

  const AddItemRol(this.rol);
}

class UpdateItemRol extends RolEvent {
  final RolesModel rol;
  const UpdateItemRol(this.rol);
}
