import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'season_event.dart';
part 'season_state.dart';

class SeasonBloc extends Bloc<SeasonEvent, SeasonState> {
  SeasonBloc() : super(const SeasonState()) {
    on<UpdateListSeason>((event, emit) => emit(state.copyWith(listSeason: event.listSeason)));

    on<AddItemSeason>((event, emit) {
      emit(state.copyWith(listSeason: [...state.listSeason, event.season]));
    });

    on<UpdateItemSeason>(((event, emit) => _onUpdateSeasonById(event, emit)));
  }
  _onUpdateSeasonById(UpdateItemSeason season, Emitter<SeasonState> emit) async {
    List<SeasonModel> listSeason = [...state.listSeason];
    listSeason[listSeason.indexWhere((e) => e.id == season.season.id)] = season.season;
    emit(state.copyWith(listSeason: listSeason));
  }
}
