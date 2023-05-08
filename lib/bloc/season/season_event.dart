part of 'season_bloc.dart';

abstract class SeasonEvent extends Equatable {
  const SeasonEvent();

  @override
  List<Object> get props => [];
}

class UpdateListSeason extends SeasonEvent {
  final List<SeasonModel> listSeason;

  const UpdateListSeason(this.listSeason);
}

class AddItemSeason extends SeasonEvent {
  final SeasonModel season;

  const AddItemSeason(this.season);
}

class UpdateItemSeason extends SeasonEvent {
  final SeasonModel season;

  const UpdateItemSeason(this.season);
}
