import 'package:flutter/material.dart';

import '../../../widgets/navigation/flexible_layout.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  static const routePath = '/projects_pages/projects';

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      builder: (Size size) {
        return const Center(
          child: Text('Projects Page'),
        );
      },
    );
  }
}
