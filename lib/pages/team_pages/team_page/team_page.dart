import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/layouts/flexible_layout.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({
    super.key,
    required this.state,
  });

  static const routePath = '/team_pages/team';

  final GoRouterState state;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: widget.state,
      builder: (Size size) {
        return const Center(
          child: Text('Team Page'),
        );
      },
    );
  }
}
