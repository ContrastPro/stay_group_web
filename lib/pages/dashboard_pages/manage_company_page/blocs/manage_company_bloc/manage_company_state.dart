part of 'manage_company_bloc.dart';

@immutable
class ManageCompanyState {
  const ManageCompanyState({
    this.status = BlocStatus.initial,
    this.userData,
    this.spaceData,
    this.company,
    this.companies = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final UserModel? spaceData;
  final CompanyModel? company;
  final List<CompanyModel> companies;

  ManageCompanyState copyWith({
    BlocStatus? status,
    UserModel? userData,
    UserModel? spaceData,
    CompanyModel? company,
    List<CompanyModel>? companies,
  }) {
    return ManageCompanyState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      spaceData: spaceData ?? this.spaceData,
      company: company ?? this.company,
      companies: companies ?? this.companies,
    );
  }
}
