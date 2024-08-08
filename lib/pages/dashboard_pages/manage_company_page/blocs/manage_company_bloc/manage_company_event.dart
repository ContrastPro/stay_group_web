part of 'manage_company_bloc.dart';

@immutable
abstract class ManageCompanyEvent {
  const ManageCompanyEvent();
}

class CreateCompany extends ManageCompanyEvent {
  const CreateCompany({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UpdateCompany extends ManageCompanyEvent {
  const UpdateCompany({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}
