part of 'subject_bloc.dart';

abstract class SubjectEvent extends Equatable {
  const SubjectEvent();

  @override
  List<Object> get props => [];
}

class UpdateListSubject extends SubjectEvent {
  final List<SubjectModel> listSubject;

  const UpdateListSubject(this.listSubject);
}

class AddItemSubject extends SubjectEvent {
  final SubjectModel subject;

  const AddItemSubject(this.subject);
}

class UpdateItemSubject extends SubjectEvent {
  final SubjectModel subject;

  const UpdateItemSubject(this.subject);
}
