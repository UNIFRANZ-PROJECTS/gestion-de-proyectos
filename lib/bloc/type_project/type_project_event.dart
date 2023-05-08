part of 'type_project_bloc.dart';

abstract class TypeProjectEvent extends Equatable {
  const TypeProjectEvent();

  @override
  List<Object> get props => [];
}

class UpdateListTypeProject extends TypeProjectEvent {
  final List<ElementModel> listElement;

  const UpdateListTypeProject(this.listElement);
}

class AddItemTypeProject extends TypeProjectEvent {
  final ElementModel element;

  const AddItemTypeProject(this.element);
}

class UpdateItemTypeProject extends TypeProjectEvent {
  final ElementModel element;

  const UpdateItemTypeProject(this.element);
}
