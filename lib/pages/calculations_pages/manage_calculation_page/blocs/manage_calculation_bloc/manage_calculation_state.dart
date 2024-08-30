part of 'manage_calculation_bloc.dart';

@immutable
class ManageCalculationState {
  const ManageCalculationState({
    this.status = BlocStatus.initial,
    this.userData,
    this.spaceData,
    this.companies = const [],
    this.projects = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final UserModel? spaceData;
  final List<CompanyModel> companies;
  final List<ProjectModel> projects;

  ManageCalculationState copyWith({
    BlocStatus? status,
    UserModel? userData,
    UserModel? spaceData,
    List<CompanyModel>? companies,
    List<ProjectModel>? projects,
  }) {
    return ManageCalculationState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      spaceData: spaceData ?? this.spaceData,
      companies: companies ?? this.companies,
      projects: projects ?? this.projects,
    );
  }
}
