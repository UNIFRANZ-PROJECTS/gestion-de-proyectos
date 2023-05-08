part of 'season_bloc.dart';

class SeasonState extends Equatable {
  final List<SeasonModel> listSeason;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const SeasonState({
    this.listSeason = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  SeasonState copyWith({
    List<SeasonModel>? listSeason,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      SeasonState(
        listSeason: listSeason ?? this.listSeason,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [
        listSeason,
        isLoading,
        ascending,
      ];
}
