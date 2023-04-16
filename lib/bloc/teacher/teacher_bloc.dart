import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  TeacherBloc() : super(const TeacherState()) {
    on<UpdateListTeacher>((event, emit) => emit(state.copyWith(listTeacher: event.listTeacher)));
    on<AddItemTeacher>((event, emit) {
      emit(state.copyWith(listTeacher: [...state.listTeacher, event.teacher]));
    });
    on<UpdateItemTeacher>(((event, emit) => _onUpdateTypeUserById(event, emit)));
  }
  _onUpdateTypeUserById(UpdateItemTeacher teacher, Emitter<TeacherState> emit) async {
    List<TeacherModel> listTeacher = [...state.listTeacher];
    listTeacher[listTeacher.indexWhere((e) => e.id == teacher.teacher.id)] = teacher.teacher;
    emit(state.copyWith(listTeacher: listTeacher));
  }
}
