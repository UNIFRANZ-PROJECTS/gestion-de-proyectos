part of 'teacher_bloc.dart';

abstract class TeacherEvent extends Equatable {
  const TeacherEvent();

  @override
  List<Object> get props => [];
}

class UpdateListTeacher extends TeacherEvent {
  final List<TeacherModel> listTeacher;

  const UpdateListTeacher(this.listTeacher);
}

class AddItemTeacher extends TeacherEvent {
  final TeacherModel teacher;

  const AddItemTeacher(this.teacher);
}

class UpdateItemTeacher extends TeacherEvent {
  final TeacherModel teacher;

  const UpdateItemTeacher(this.teacher);
}
