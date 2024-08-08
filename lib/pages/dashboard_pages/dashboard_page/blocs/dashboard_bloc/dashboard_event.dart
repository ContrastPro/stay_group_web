part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
  const DashboardEvent();
}

class GetCompanies extends DashboardEvent {
  const GetCompanies();
}

class DeleteCompany extends DashboardEvent {
  const DeleteCompany({
    required this.id,
  });

  final String id;
}
