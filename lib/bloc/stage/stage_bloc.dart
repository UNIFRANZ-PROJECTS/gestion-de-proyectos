import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'stage_event.dart';
part 'stage_state.dart';

class StageBloc extends Bloc<StageEvent, StageState> {
  StageBloc() : super(const StageState()) {
    on<UpdateListStage>((event, emit) => emit(state.copyWith(listStage: event.listStage)));

    on<AddItemStage>((event, emit) {
      emit(state.copyWith(listStage: [...state.listStage, event.stage]));
    });

    on<UpdateItemStage>(((event, emit) => _onUpdateStageById(event, emit)));
  }
  _onUpdateStageById(UpdateItemStage stage, Emitter<StageState> emit) async {
    List<StageModel> listStage = [...state.listStage];
    listStage[listStage.indexWhere((e) => e.id == stage.stage.id)] = stage.stage;
    emit(state.copyWith(listStage: listStage));
  }
}
