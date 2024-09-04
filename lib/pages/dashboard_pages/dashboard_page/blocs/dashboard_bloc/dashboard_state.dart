part of 'dashboard_bloc.dart';

@immutable
class DashboardState {
  const DashboardState({
    this.status = BlocStatus.initial,
    this.userData,
    this.companies = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final List<CompanyModel> companies;

  DashboardState copyWith({
    BlocStatus? status,
    UserModel? userData,
    List<CompanyModel>? companies,
  }) {
    return DashboardState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      companies: companies ?? this.companies,
    );
  }
}
