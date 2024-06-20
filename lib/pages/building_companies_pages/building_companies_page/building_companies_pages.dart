import 'package:flutter/material.dart';

import '../../../widgets/navigation/flexible_layout.dart';

class BuildingCompaniesPage extends StatefulWidget {
  const BuildingCompaniesPage({super.key});

  static const routeName = '/';

  @override
  State<BuildingCompaniesPage> createState() => _BuildingCompaniesPageState();
}

class _BuildingCompaniesPageState extends State<BuildingCompaniesPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      builder: (Size size) {
        return const Center(
          child: Text('Building Companies Page'),
        );
      },
    );
  }
}
