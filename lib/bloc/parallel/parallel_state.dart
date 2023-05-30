part of 'parallel_bloc.dart';

class ParallelState extends Equatable {
  final List<ParallelModel> listParallel;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const ParallelState({
    this.listParallel = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  ParallelState copyWith({
    List<ParallelModel>? listParallel,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      ParallelState(
        listParallel: listParallel ?? this.listParallel,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [
        listParallel,
        isLoading,
        ascending,
      ];
}
