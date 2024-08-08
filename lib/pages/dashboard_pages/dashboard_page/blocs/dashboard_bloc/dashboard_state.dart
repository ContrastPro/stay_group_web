part of 'dashboard_bloc.dart';

@immutable
class DashboardState {
  const DashboardState({
    this.status = BlocStatus.initial,
    this.companies = const [],
  });

  final BlocStatus status;
  final List<CompanyModel> companies;

  DashboardState copyWith({
    BlocStatus? status,
    List<CompanyModel>? companies,
  }) {
    return DashboardState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
    );
  }
}
