import 'package:flutter/material.dart';

import '../../../widgets/navigation/flexible_layout.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  static const routeName = '/team_pages/team';

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      builder: (Size size) {
        return const Center(
          child: Text('Team Page'),
        );
      },
    );
  }
}
