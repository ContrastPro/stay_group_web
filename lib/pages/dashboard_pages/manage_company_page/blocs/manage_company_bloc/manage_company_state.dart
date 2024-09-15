part of 'manage_company_bloc.dart';

@immutable
class ManageCompanyState {
  const ManageCompanyState({
    this.status = BlocStatus.initial,
    this.userData,
    this.company,
    this.companies = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final CompanyModel? company;
  final List<CompanyModel> companies;

  ManageCompanyState copyWith({
    BlocStatus? status,
    UserModel? userData,
    CompanyModel? company,
    List<CompanyModel>? companies,
  }) {
    return ManageCompanyState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      company: company ?? this.company,
      companies: companies ?? this.companies,
    );
  }
}
