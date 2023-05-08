part of 'requirement_bloc.dart';

class RequirementState extends Equatable {
  final List<RequirementModel> listRequirement;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;

  const RequirementState({
    this.listRequirement = const [],
    this.isLoading = true,
    this.ascending = true,
    this.sortColumnIndex,
  });
  RequirementState copyWith({
    List<RequirementModel>? listRequirement,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      RequirementState(
        listRequirement: listRequirement ?? this.listRequirement,
        isLoading: isLoading ?? this.isLoading,
        ascending: ascending ?? this.ascending,
        sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex,
      );
  @override
  List<Object> get props => [
        listRequirement,
        isLoading,
        ascending,
      ];
}
