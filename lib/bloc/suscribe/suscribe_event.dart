part of 'suscribe_bloc.dart';

abstract class SuscribeEvent extends Equatable {
  const SuscribeEvent();

  @override
  List<Object> get props => [];
}

class UpdateListSuscribe extends SuscribeEvent {
  final List<SuscribeModel> listSuscribe;

  const UpdateListSuscribe(this.listSuscribe);
}

class AddItemSuscribe extends SuscribeEvent {
  final SuscribeModel suscribe;

  const AddItemSuscribe(this.suscribe);
}

class UpdateItemSuscribe extends SuscribeEvent {
  final SuscribeModel suscribe;

  const UpdateItemSuscribe(this.suscribe);
}
