part of 'type_user_bloc.dart';

abstract class TypeUserEvent extends Equatable {
  const TypeUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateListTypeUser extends TypeUserEvent {
  final List<TypeUserModel> listTypeUser;

  const UpdateListTypeUser(this.listTypeUser);
}

class UpdateSortColumnIndexTypeUser extends TypeUserEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexTypeUser(this.sortColumnIndex);
}

class AddItemTypeUser extends TypeUserEvent {
  final TypeUserModel typeUser;

  const AddItemTypeUser(this.typeUser);
}

class UpdateItemTypeUser extends TypeUserEvent {
  final TypeUserModel typeUser;
  const UpdateItemTypeUser(this.typeUser);
}
