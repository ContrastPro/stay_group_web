import 'package:flutter/material.dart';

import '../../../widgets/navigation/flexible_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const routePath = '/dashboard_pages/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      builder: (Size size) {
        return const Center(
          child: Text('Dashboard Page'),
        );
      },
    );
  }
}
