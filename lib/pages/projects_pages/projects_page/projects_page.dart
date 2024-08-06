import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/app_animations.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({
    super.key,
    required this.state,
  });

  static const routePath = '/projects_pages/projects';

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: state,
      builder: (Size size) {
        return const _ProjectsPageContent();
      },
    );
  }
}

class _ProjectsPageContent extends StatelessWidget {
  const _ProjectsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: EmptyStateView(
        isEmpty: true,
        animation: AppAnimations.addProject,
        title: 'Add first project',
        description:
            "You don't added your first project yet - let's get started!",
        buttonWidth: 160.0,
        buttonText: 'Add project',
        onTap: () {
          //
        },
        content: const Center(
          child: Text('Projects Page'),
        ),
      ),
    );
  }
}
