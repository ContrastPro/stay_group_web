part of 'manage_calculation_bloc.dart';

@immutable
class ManageCalculationState {
  const ManageCalculationState({
    this.status = BlocStatus.initial,
    this.userData,
    this.companies = const [],
    this.projects = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final List<CompanyModel> companies;
  final List<ProjectModel> projects;

  ManageCalculationState copyWith({
    BlocStatus? status,
    UserModel? userData,
    List<CompanyModel>? companies,
    List<ProjectModel>? projects,
  }) {
    return ManageCalculationState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      companies: companies ?? this.companies,
      projects: projects ?? this.projects,
    );
  }
}
