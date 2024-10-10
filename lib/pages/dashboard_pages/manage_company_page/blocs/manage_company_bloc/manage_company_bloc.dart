import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/companies/company_model.dart';
import '../../../../../models/companies/company_response_model.dart';
import '../../../../../models/medias/media_model.dart';
import '../../../../../models/medias/media_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/companies_repository.dart';
import '../../../../../repositories/storage_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_company_event.dart';

part 'manage_company_state.dart';

class ManageCompanyBloc extends Bloc<ManageCompanyEvent, ManageCompanyState> {
  ManageCompanyBloc({
    required this.authRepository,
    required this.usersRepository,
    required this.companiesRepository,
    required this.storageRepository,
  }) : super(const ManageCompanyState()) {
    on<Init>((event, emit) async {
      await requestDelay();

      final User? user = authRepository.currentUser();

      final UserModel? response = await usersRepository.getUserById(
        userId: user!.uid,
      );

      final String spaceId = response!.info.role == UserRole.manager
          ? response.userId!
          : response.spaceId!;

      UserModel? spaceData;

      if (response.info.role == UserRole.worker) {
        spaceData = await usersRepository.getUserById(
          userId: spaceId,
        );
      }

      CompanyModel? company;
      final List<CompanyModel> companies = [];

      final CompanyResponseModel? savedCompanies =
          await companiesRepository.getCompanies(spaceId: spaceId);

      if (savedCompanies != null) {
        companies.addAll(savedCompanies.companies);

        company = companies.firstWhereOrNull(
          (e) => e.id == event.id,
        );
      }

      emit(
        state.copyWith(
          userData: response,
          spaceData: spaceData,
          company: company,
          companies: companies,
        ),
      );
    });

    on<CreateCompany>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      if (event.media.isEmpty) {
        await requestDelay();
      }

      final String spaceId = state.userData!.info.role == UserRole.manager
          ? state.userData!.userId!
          : state.userData!.spaceId!;

      final List<MediaModel> media = [];

      for (int i = 0; i < event.media.length; i++) {
        final String data = await storageRepository.uploadMedia(
          isThumbnail: false,
          spaceId: spaceId,
          id: event.media[i].id,
          data: event.media[i].data!,
          format: event.media[i].format,
        );

        final String thumbnail = await storageRepository.uploadMedia(
          isThumbnail: true,
          spaceId: spaceId,
          id: event.media[i].id,
          data: event.media[i].thumbnail!,
          format: event.media[i].format,
        );

        media.add(
          MediaModel(
            id: event.media[i].id,
            data: data,
            thumbnail: thumbnail,
            format: event.media[i].format,
            name: event.media[i].name,
          ),
        );
      }

      final String id = uuid();

      await companiesRepository.createCompany(
        spaceId: spaceId,
        id: id,
        media: media.isNotEmpty ? media : null,
        name: event.name,
        description: event.description,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
    });

    on<UpdateCompany>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      if (event.addedMedia.isEmpty && event.removedMedia.isEmpty) {
        await requestDelay();
      }

      final String spaceId = state.userData!.info.role == UserRole.manager
          ? state.userData!.userId!
          : state.userData!.spaceId!;

      final List<MediaModel> media = [...event.savedMedia];

      for (int i = 0; i < event.addedMedia.length; i++) {
        final String data = await storageRepository.uploadMedia(
          isThumbnail: false,
          spaceId: spaceId,
          id: event.addedMedia[i].id,
          data: event.addedMedia[i].data!,
          format: event.addedMedia[i].format,
        );

        final String thumbnail = await storageRepository.uploadMedia(
          isThumbnail: true,
          spaceId: spaceId,
          id: event.addedMedia[i].id,
          data: event.addedMedia[i].thumbnail!,
          format: event.addedMedia[i].format,
        );

        media.add(
          MediaModel(
            id: event.addedMedia[i].id,
            data: data,
            thumbnail: thumbnail,
            format: event.addedMedia[i].format,
            name: event.addedMedia[i].name,
          ),
        );
      }

      for (int i = 0; i < event.removedMedia.length; i++) {
        await storageRepository.deleteMedia(
          isThumbnail: false,
          spaceId: spaceId,
          id: event.removedMedia[i].id,
        );

        await storageRepository.deleteMedia(
          isThumbnail: true,
          spaceId: spaceId,
          id: event.removedMedia[i].id,
        );
      }

      await companiesRepository.updateCompany(
        spaceId: spaceId,
        id: state.company!.id,
        media: media.isNotEmpty ? media : null,
        name: event.name,
        description: event.description,
        createdAt: state.company!.metadata.createdAt,
      );

      emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
        ),
      );
    });
  }

  final AuthRepository authRepository;
  final UsersRepository usersRepository;
  final CompaniesRepository companiesRepository;
  final StorageRepository storageRepository;
}
