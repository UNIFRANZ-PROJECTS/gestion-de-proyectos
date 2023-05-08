part of 'stage_bloc.dart';

abstract class StageEvent extends Equatable {
  const StageEvent();

  @override
  List<Object> get props => [];
}

class UpdateListStage extends StageEvent {
  final List<StageModel> listStage;

  const UpdateListStage(this.listStage);
}

class AddItemStage extends StageEvent {
  final StageModel stage;

  const AddItemStage(this.stage);
}

class UpdateItemStage extends StageEvent {
  final StageModel stage;

  const UpdateItemStage(this.stage);
}
