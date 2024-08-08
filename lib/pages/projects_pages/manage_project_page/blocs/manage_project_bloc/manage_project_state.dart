part of 'manage_project_bloc.dart';

@immutable
class ManageProjectState {
  const ManageProjectState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  ManageProjectState copyWith({
    BlocStatus? status,
  }) {
    return ManageProjectState(
      status: status ?? this.status,
    );
  }
}
