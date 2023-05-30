import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'suscribe_event.dart';
part 'suscribe_state.dart';

class SuscribeBloc extends Bloc<SuscribeEvent, SuscribeState> {
  SuscribeBloc() : super(const SuscribeState()) {
    on<UpdateListSuscribe>((event, emit) => emit(state.copyWith(listSuscribe: event.listSuscribe)));
    on<AddItemSuscribe>((event, emit) {
      emit(state.copyWith(listSuscribe: [...state.listSuscribe, event.suscribe]));
    });
    on<UpdateItemSuscribe>(((event, emit) => _onUpdateSuscribeById(event, emit)));
  }
  _onUpdateSuscribeById(UpdateItemSuscribe suscribe, Emitter<SuscribeState> emit) async {
    List<SuscribeModel> listSuscribe = [...state.listSuscribe];
    listSuscribe[listSuscribe.indexWhere((e) => e.id == suscribe.suscribe.id)] = suscribe.suscribe;
    emit(state.copyWith(listSuscribe: listSuscribe));
  }
}
