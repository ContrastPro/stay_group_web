part of 'manage_company_bloc.dart';

@immutable
class ManageCompanyState {
  const ManageCompanyState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  ManageCompanyState copyWith({
    BlocStatus? status,
  }) {
    return ManageCompanyState(
      status: status ?? this.status,
    );
  }
}
