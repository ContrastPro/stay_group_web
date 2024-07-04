import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/layouts/flexible_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.state,
  });

  static const routePath = '/dashboard_pages/dashboard';

  final GoRouterState state;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: widget.state,
      builder: (Size size) {
        return const Center(
          child: Text('Dashboard Page'),
        );
      },
    );
  }
}
