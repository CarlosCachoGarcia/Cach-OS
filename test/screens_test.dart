import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/app.dart';
import 'package:tienda_aula/core/dependencies.dart';
import 'package:tienda_aula/models/app_user.dart';

import 'support.dart';

void main() {
  testWidgets('Login valida campos vacíos', (tester) async {
    await tester.pumpWidget(
      StoreApp(Dependencies(api: FakeApi(), storage: MemoryStorage())),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    expect(find.text('Escribe tu usuario'), findsOneWidget);
    expect(find.text('Escribe tu contraseña'), findsOneWidget);
  });
  testWidgets('Cliente: ruta de inventario bloqueada y logout sin retroceso', (
    tester,
  ) async {
    final deps = Dependencies(api: FakeApi(), storage: MemoryStorage());
    deps.session.start(const AppUser(id: 4, username: 'client'), tokenFor(4));
    await tester.pumpWidget(StoreApp(deps));
    await tester.pumpAndSettle();
    final nav = tester.state<NavigatorState>(find.byType(Navigator));
    nav.pushNamed('/product/new');
    await tester.pumpAndSettle();
    expect(find.text('Guardar producto'), findsNothing);
    expect(find.text('Explora el catálogo'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('Usuarios'), findsNothing);
    expect(find.text('Histórico de carritos'), findsNothing);
    await tester.tap(find.text('Cerrar sesión'));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(nav.canPop(), false);
    expect(deps.session.user, isNull);
  });
  testWidgets('Carrito vacío desactiva pago', (tester) async {
    final deps = Dependencies(api: FakeApi(), storage: MemoryStorage());
    deps.session.start(const AppUser(id: 4, username: 'client'), tokenFor(4));
    await tester.pumpWidget(StoreApp(deps));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/cart');
    await tester.pumpAndSettle();
    expect(
      find.text('Tu carrito está vacío, explora el catálogo'),
      findsOneWidget,
    );
    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Proceder al pago'),
    );
    expect(button.onPressed, isNull);
  });
}
