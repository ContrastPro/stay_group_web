import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/medias/media_model.dart';
import '../../../../../models/medias/media_response_model.dart';
import '../../../../../models/projects/project_model.dart';
import '../../../../../models/projects/project_response_model.dart';
import '../../../../../models/users/user_info_model.dart';
import '../../../../../models/users/user_model.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../repositories/projects_repository.dart';
import '../../../../../repositories/storage_repository.dart';
import '../../../../../repositories/users_repository.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/helpers.dart';

part 'manage_project_event.dart';

part 'manage_project_state.dart';

class ManageProjectBloc extends Bloc<ManageProjectEvent, ManageProjectState> {
  ManageProjectBloc({
    required this.authRepository,
    required this.projectsRepository,
    required this.storageRepository,
    required this.usersRepository,
  }) : super(const ManageProjectState()) {
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

      ProjectModel? project;
      final List<ProjectModel> projects = [];

      final ProjectResponseModel? savedProjects =
          await projectsRepository.getProjects(spaceId: spaceId);

      if (savedProjects != null) {
        projects.addAll(savedProjects.projects);

        project = projects.firstWhereOrNull(
          (e) => e.id == event.id,
        );
      }

      emit(
        state.copyWith(
          userData: response,
          spaceData: spaceData,
          project: project,
          projects: projects,
        ),
      );
    });

    on<CreateProject>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

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

      await projectsRepository.createProject(
        spaceId: spaceId,
        id: id,
        media: media.isNotEmpty ? media : null,
        name: event.name,
        location: event.location,
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

    on<UpdateProject>((event, emit) async {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );

      await requestDelay();

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

      await projectsRepository.updateProject(
        spaceId: spaceId,
        id: state.project!.id,
        media: media.isNotEmpty ? media : null,
        name: event.name,
        location: event.location,
        description: event.description,
        createdAt: state.project!.metadata.createdAt,
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
  final ProjectsRepository projectsRepository;
  final StorageRepository storageRepository;
  final UsersRepository usersRepository;
}
