part of 'stage_bloc.dart';

class StageState extends Equatable {
  final List<StageModel> listStage;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const StageState({
    this.listStage = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  StageState copyWith({
    List<StageModel>? listStage,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      StageState(
        listStage: listStage ?? this.listStage,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [
        listStage,
        isLoading,
        ascending,
      ];
}
