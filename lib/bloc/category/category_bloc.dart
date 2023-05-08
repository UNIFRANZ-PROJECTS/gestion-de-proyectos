import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState()) {
    on<UpdateListCategory>((event, emit) => emit(state.copyWith(listCategory: event.listElement)));

    on<AddItemCategory>((event, emit) {
      emit(state.copyWith(listCategory: [...state.listCategory, event.element]));
    });

    on<UpdateItemCategory>(((event, emit) => _onUpdateCategoryById(event, emit)));
  }
  _onUpdateCategoryById(UpdateItemCategory category, Emitter<CategoryState> emit) async {
    List<ElementModel> listCategory = [...state.listCategory];
    listCategory[listCategory.indexWhere((e) => e.id == category.element.id)] = category.element;
    emit(state.copyWith(listCategory: listCategory));
  }
}
