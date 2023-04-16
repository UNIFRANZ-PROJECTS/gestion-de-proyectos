import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(const ProjectState()) {
    on<UpdateListProject>((event, emit) => emit(state.copyWith(listProject: event.listProject)));
  }
}
