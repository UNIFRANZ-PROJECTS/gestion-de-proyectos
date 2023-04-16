part of 'permision_bloc.dart';

abstract class PermisionEvent extends Equatable {
  const PermisionEvent();

  @override
  List<Object> get props => [];
}

class UpdateListPermision extends PermisionEvent {
  final List<PermisionsModel> listPermision;

  const UpdateListPermision(this.listPermision);
}

class UpdateSortColumnIndexPermision extends PermisionEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexPermision(this.sortColumnIndex);
}
