part of 'manage_calculation_bloc.dart';

@immutable
class ManageCalculationState {
  const ManageCalculationState({
    this.status = BlocStatus.initial,
    this.userData,
    this.spaceData,
    this.calculation,
    this.companies = const [],
    this.projects = const [],
    this.calculations = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final UserModel? spaceData;
  final CalculationModel? calculation;
  final List<CompanyModel> companies;
  final List<ProjectModel> projects;
  final List<CalculationModel> calculations;

  ManageCalculationState copyWith({
    BlocStatus? status,
    UserModel? userData,
    UserModel? spaceData,
    CalculationModel? calculation,
    List<CompanyModel>? companies,
    List<ProjectModel>? projects,
    List<CalculationModel>? calculations,
  }) {
    return ManageCalculationState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      calculation: calculation ?? this.calculation,
      spaceData: spaceData ?? this.spaceData,
      companies: companies ?? this.companies,
      projects: projects ?? this.projects,
      calculations: calculations ?? this.calculations,
    );
  }
}
