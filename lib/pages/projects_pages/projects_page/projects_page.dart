import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/layouts/flexible_layout.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({
    super.key,
    required this.state,
  });

  static const routePath = '/projects_pages/projects';

  final GoRouterState state;

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: widget.state,
      builder: (Size size) {
        return const Center(
          child: Text('Projects Page'),
        );
      },
    );
  }
}
