import 'package:flutter/material.dart';

import 'core/dependencies.dart';
import 'features/autenticacion/login_screen.dart';
import 'features/autenticacion/session_screen.dart';
import 'features/catalogo/catalog_screen.dart';

class StoreApp extends StatelessWidget {
  final Dependencies deps;
  const StoreApp(this.deps, {super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Tienda Aula',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff176b59)),
          scaffoldBackgroundColor: const Color(0xfff5f7f5),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          final s = deps.session;
          final name = settings.name;
          Widget screen = name == '/' ? SessionScreen(deps) : LoginScreen(deps);
          if (s.active) {
            screen = CatalogScreen(
              deps,
            ); // Toda ruta desconocida o sin permisos vuelve al catálogo.
          }
          return MaterialPageRoute(builder: (_) => screen, settings: settings);
        },
      );
}
