part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateListUser extends UserEvent {
  final List<UserModel> listUsers;

  const UpdateListUser(this.listUsers);
}

class UpdateSortColumnIndexUser extends UserEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexUser(this.sortColumnIndex);
}

class AddItemUser extends UserEvent {
  final UserModel user;

  const AddItemUser(this.user);
}

class UpdateItemUser extends UserEvent {
  final UserModel user;
  const UpdateItemUser(this.user);
}
