import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/app_animations.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.state,
  });

  static const routePath = '/dashboard_pages/dashboard';

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: state,
      builder: (Size size) {
        return const _DashboardPageContent();
      },
    );
  }
}

class _DashboardPageContent extends StatelessWidget {
  const _DashboardPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: EmptyStateView(
        isEmpty: true,
        animation: AppAnimations.addCompany,
        title: 'Add first company',
        description:
            "You don't added your first company yet - let's get started!",
        buttonWidth: 180.0,
        buttonText: 'Add company',
        onTap: () {
          //
        },
        content: const Center(
          child: Text('Dashboard Page'),
        ),
      ),
    );
  }
}
