part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
  const DashboardEvent();
}

class Init extends DashboardEvent {
  const Init();
}

class DeleteCompany extends DashboardEvent {
  const DeleteCompany({
    required this.id,
  });

  final String id;
}
