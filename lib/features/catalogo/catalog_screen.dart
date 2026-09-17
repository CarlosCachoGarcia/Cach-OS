import 'package:flutter/material.dart';
import '../../core/dependencies.dart';
import '../../models/app_user.dart';

class CatalogScreen extends StatelessWidget {
  final Dependencies deps;
  const CatalogScreen(this.deps, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Tienda Aula'),
      ),
      body: Center(
          child: Text(
              'Sesión de ${deps.session.user?.username} · ${deps.session.role?.label}')));
}
