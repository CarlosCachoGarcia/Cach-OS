import 'package:flutter/material.dart';
import '../../core/dependencies.dart';
import '../../models/app_user.dart';
import '../../widgets/common.dart';

class CatalogScreen extends StatelessWidget {
  final Dependencies deps;
  const CatalogScreen(this.deps, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Tienda Aula'),
        actions: [
          TextButton(
              onPressed: () async {
                final ok = await deps.auth.logout();
                if (!context.mounted) return;
                if (ok) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (_) => false);
                } else {
                  message(context, deps.auth.error!, error: true);
                }
              },
              child: const Text('Cerrar sesión'))
        ],
      ),
      body: Center(
          child: Text(
              'Sesión de ${deps.session.user?.username} · ${deps.session.role?.label}')));
}
