part of 'requirement_bloc.dart';

abstract class RequirementEvent extends Equatable {
  const RequirementEvent();

  @override
  List<Object> get props => [];
}

class UpdateListRequirement extends RequirementEvent {
  final List<RequirementModel> listRequirement;

  const UpdateListRequirement(this.listRequirement);
}

class AddItemRequirement extends RequirementEvent {
  final RequirementModel requirement;

  const AddItemRequirement(this.requirement);
}

class UpdateItemRequirement extends RequirementEvent {
  final RequirementModel requirement;

  const UpdateItemRequirement(this.requirement);
}
