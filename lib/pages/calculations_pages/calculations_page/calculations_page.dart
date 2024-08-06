import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../resources/app_animations.dart';
import '../../../utils/constants.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({
    super.key,
    required this.state,
  });

  static const routePath = '/calculations_pages/calculations';

  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      state: state,
      builder: (Size size) {
        return const _CalculationsPageContent();
      },
    );
  }
}

class _CalculationsPageContent extends StatelessWidget {
  const _CalculationsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: EmptyStateView(
        isEmpty: true,
        animation: AppAnimations.addCalculation,
        title: 'Add first calculation',
        description:
            "You don't added your first calculation yet - let's get started!",
        buttonWidth: 190.0,
        buttonText: 'Add calculation',
        onTap: () {
          //
        },
        content: const Center(
          child: Text('Calculation Page'),
        ),
      ),
    );
  }
}
