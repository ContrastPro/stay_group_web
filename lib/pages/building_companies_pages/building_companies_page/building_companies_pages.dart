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
    return const FlexibleLayout(
      body: Text('Building Companies Page'),
    );
  }
}
