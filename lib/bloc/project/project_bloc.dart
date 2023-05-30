import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gestion_projects/models/models.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(const ProjectState()) {
    on<UpdateListProject>((event, emit) => emit(state.copyWith(listProject: event.listProject)));
    on<AddItemProject>((event, emit) {
      emit(state.copyWith(listProject: [...state.listProject, event.project]));
    });
    on<UpdateItemProject>(((event, emit) => _onUpdateProjectById(event, emit)));
  }
  _onUpdateProjectById(UpdateItemProject project, Emitter<ProjectState> emit) async {
    List<ProjectModel> listProject = [...state.listProject];
    listProject[listProject.indexWhere((e) => e.project.id == project.project.project.id)] = project.project;
    debugPrint('=============update');
    debugPrint(json.encode(listProject));
    debugPrint('=============update');
    emit(state.copyWith(listProject: listProject));
  }
}
