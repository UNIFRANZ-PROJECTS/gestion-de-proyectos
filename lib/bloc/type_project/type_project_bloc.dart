import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'type_project_event.dart';
part 'type_project_state.dart';

class TypeProjectBloc extends Bloc<TypeProjectEvent, TypeProjectState> {
  TypeProjectBloc() : super(const TypeProjectState()) {
    on<UpdateListTypeProject>((event, emit) => emit(state.copyWith(listTypeProject: event.listElement)));

    on<AddItemTypeProject>((event, emit) {
      emit(state.copyWith(listTypeProject: [...state.listTypeProject, event.element]));
    });

    on<UpdateItemTypeProject>(((event, emit) => _onUpdateTypeProjectById(event, emit)));
  }
  _onUpdateTypeProjectById(UpdateItemTypeProject typeProject, Emitter<TypeProjectState> emit) async {
    List<ElementModel> listTypeProject = [...state.listTypeProject];
    listTypeProject[listTypeProject.indexWhere((e) => e.id == typeProject.element.id)] = typeProject.element;
    emit(state.copyWith(listTypeProject: listTypeProject));
  }
}
