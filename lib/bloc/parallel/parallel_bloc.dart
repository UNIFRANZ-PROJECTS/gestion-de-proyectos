import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'parallel_event.dart';
part 'parallel_state.dart';

class ParallelBloc extends Bloc<ParallelEvent, ParallelState> {
  ParallelBloc() : super(const ParallelState()) {
    on<UpdateListParallel>((event, emit) => emit(state.copyWith(listParallel: event.listParallel)));
    on<AddItemParallel>((event, emit) {
      emit(state.copyWith(listParallel: [...state.listParallel, event.parallel]));
    });
    on<UpdateItemParallel>(((event, emit) => _onUpdateParallelById(event, emit)));
  }
  _onUpdateParallelById(UpdateItemParallel parallel, Emitter<ParallelState> emit) async {
    List<ParallelModel> listParallel = [...state.listParallel];
    listParallel[listParallel.indexWhere((e) => e.id == parallel.parallel.id)] = parallel.parallel;
    emit(state.copyWith(listParallel: listParallel));
  }
}
