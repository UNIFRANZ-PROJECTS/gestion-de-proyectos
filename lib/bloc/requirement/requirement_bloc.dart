import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'requirement_event.dart';
part 'requirement_state.dart';

class RequirementBloc extends Bloc<RequirementEvent, RequirementState> {
  RequirementBloc() : super(const RequirementState()) {
    on<UpdateListRequirement>((event, emit) => emit(state.copyWith(listRequirement: event.listRequirement)));

    on<AddItemRequirement>((event, emit) {
      emit(state.copyWith(listRequirement: [...state.listRequirement, event.requirement]));
    });

    on<UpdateItemRequirement>(((event, emit) => _onUpdateRequirementById(event, emit)));
  }
  _onUpdateRequirementById(UpdateItemRequirement requirement, Emitter<RequirementState> emit) async {
    List<RequirementModel> listRequirement = [...state.listRequirement];
    listRequirement[listRequirement.indexWhere((e) => e.id == requirement.requirement.id)] = requirement.requirement;
    emit(state.copyWith(listRequirement: listRequirement));
  }
}
