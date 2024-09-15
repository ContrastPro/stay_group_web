part of 'manage_company_bloc.dart';

@immutable
abstract class ManageCompanyEvent {
  const ManageCompanyEvent();
}

class Init extends ManageCompanyEvent {
  const Init({
    this.id,
  });

  final String? id;
}

class CreateCompany extends ManageCompanyEvent {
  const CreateCompany({
    required this.media,
    required this.name,
    required this.description,
  });

  final List<MediaResponseModel> media;
  final String name;
  final String description;
}

class UpdateCompany extends ManageCompanyEvent {
  const UpdateCompany({
    required this.savedMedia,
    required this.addedMedia,
    required this.removedMedia,
    required this.name,
    required this.description,
  });

  final List<MediaModel> savedMedia;
  final List<MediaResponseModel> addedMedia;
  final List<MediaModel> removedMedia;
  final String name;
  final String description;
}
