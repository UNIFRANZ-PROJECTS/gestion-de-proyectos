import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gestion_projects/models/models.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc() : super(const SubjectState()) {
    on<UpdateListSubject>((event, emit) => emit(state.copyWith(listSubject: event.listSubject)));
    on<AddItemSubject>((event, emit) {
      emit(state.copyWith(listSubject: [...state.listSubject, event.subject]));
    });
    on<UpdateItemSubject>(((event, emit) => _onUpdateTypeUserById(event, emit)));
  }
  _onUpdateTypeUserById(UpdateItemSubject subject, Emitter<SubjectState> emit) async {
    List<SubjectModel> listSubject = [...state.listSubject];
    listSubject[listSubject.indexWhere((e) => e.id == subject.subject.id)] = subject.subject;
    emit(state.copyWith(listSubject: listSubject));
  }
}
