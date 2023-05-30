part of 'parallel_bloc.dart';

abstract class ParallelEvent extends Equatable {
  const ParallelEvent();

  @override
  List<Object> get props => [];
}

class UpdateListParallel extends ParallelEvent {
  final List<ParallelModel> listParallel;

  const UpdateListParallel(this.listParallel);
}

class AddItemParallel extends ParallelEvent {
  final ParallelModel parallel;

  const AddItemParallel(this.parallel);
}

class UpdateItemParallel extends ParallelEvent {
  final ParallelModel parallel;

  const UpdateItemParallel(this.parallel);
}
