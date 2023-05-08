part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<ElementModel> listCategory;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const CategoryState({
    this.listCategory = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  CategoryState copyWith({
    List<ElementModel>? listCategory,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      CategoryState(
        listCategory: listCategory ?? this.listCategory,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );

  @override
  List<Object> get props => [listCategory, isLoading, ascending];
}
