part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class UpdateListCategory extends CategoryEvent {
  final List<ElementModel> listElement;

  const UpdateListCategory(this.listElement);
}

class AddItemCategory extends CategoryEvent {
  final ElementModel element;

  const AddItemCategory(this.element);
}

class UpdateItemCategory extends CategoryEvent {
  final ElementModel element;

  const UpdateItemCategory(this.element);
}
