import 'package:flutter_test/flutter_test.dart';
import 'package:tienda_aula/models/app_user.dart';
import 'package:tienda_aula/core/session.dart';
import 'package:tienda_aula/repositories/product_repository.dart';
import 'package:tienda_aula/repositories/cart_repository.dart';
import 'package:tienda_aula/repositories/audit_repository.dart';
import 'package:tienda_aula/repositories/auth_repository.dart';
import 'package:tienda_aula/features/compras/cart_view_model.dart';
import 'package:tienda_aula/features/catalogo/catalog_view_model.dart';
import 'package:tienda_aula/features/inventario/product_form_view_model.dart';

import 'support.dart';

void main() {
  test(
    'US01: roles por ID y modelos anidados tolerantes a campos ausentes',
    () {
      expect([1, 2, 3, 4, 10].map(roleFor), [
        Role.admin,
        Role.admin,
        Role.auditor,
        Role.client,
        Role.client,
      ]);
      expect(AppUser.fromJson({'id': 4}).address.city, '');
    },
  );
  test('US01/02: guarda, restaura y elimina sesión', () async {
    final api = FakeApi(), storage = MemoryStorage(), session = Session();
    final auth = AuthRepository(api, storage, session);
    await auth.login('student', 'password');
    expect(session.role, Role.client);
    expect(storage.token, isNotNull);
    session.clear();
    await auth.restore();
    expect(session.user!.id, 4);
    await auth.logout();
    expect(session.active, false);
    expect(session.role, isNull);
    expect(storage.token, isNull);
  });
  test('US06/07/08: clientes y auditores no envían escrituras', () async {
    for (final id in [3, 4]) {
      final api = FakeApi(), repo = ProductRepository(FakeApi(), signedIn(id));
      final guarded = ProductRepository(api, repo.session);
      await expectLater(guarded.save(product, creating: true), throwsException);
      await expectLater(
        guarded.save(product, creating: false),
        throwsException,
      );
      await expectLater(guarded.delete(1), throwsException);
      expect(api.calls, isEmpty);
    }
  });
  test('US11/12: cliente no consulta auditoría', () async {
    final api = FakeApi(), session = signedIn(4);
    final repo = AuditRepository(api, session);
    await expectLater(repo.users(), throwsException);
    await expectLater(repo.carts(), throwsException);
    expect(api.calls, isEmpty);
  });
  test('US09: auditor no puede modificar carrito', () async {
    final api = FakeApi();
    await expectLater(
      CartRepository(api, signedIn(3)).add([]),
      throwsException,
    );
    expect(api.calls, isEmpty);
  });
  test('US03/04: filtrar usa endpoint y restablece catálogo', () async {
    final api = FakeApi();
    final vm = CatalogViewModel(ProductRepository(api, signedIn(4)));
    await vm.load('Accesorios');
    expect(api.calls, contains('GET /products/category/Accesorios'));
    await vm.load();
    expect(vm.category, isNull);
    expect(vm.products.length, 1);
    api.fail = true;
    expect(await vm.load(), false);
    expect(vm.busy, false);
    expect(vm.products, isEmpty);
    expect(vm.error, isNotNull);
  });
  test('US06/07: validación de precio, campos y URL', () {
    for (final value in ['', 'abc', '0', '-1', 'NaN', 'Infinity']) {
      expect(ProductFormViewModel.price(value), isNotNull);
    }
    expect(ProductFormViewModel.price('12,50'), isNull);
    expect(ProductFormViewModel.requiredText('  '), isNotNull);
    expect(ProductFormViewModel.imageUrl('ftp://example.com/a'), isNotNull);
    expect(ProductFormViewModel.imageUrl('https://example.com/a'), isNull);
  });
  test(
    'US09/10: suma duplicados, calcula, modifica, elimina y limpia',
    () async {
      final api = FakeApi();
      final vm = CartViewModel(CartRepository(api, signedIn(4)));
      await vm.add(product, 2);
      await vm.add(product, 1);
      expect(vm.lines.length, 1);
      expect(vm.count, 3);
      expect(vm.totalCents, 5997);
      await vm.change(vm.lines.single, 2);
      expect(vm.totalCents, 3998);
      expect(api.calls, contains('PUT /carts/11'));
      await vm.change(vm.lines.single, 0);
      expect(vm.lines, isEmpty);
      expect(vm.totalCents, 0);
      expect(api.calls, contains('DELETE /carts/11'));
      await vm.add(product, 1);
      vm.clear();
      expect(vm.cartId, isNull);
      expect(vm.count, 0);
    },
  );
  test('US09/10: falla de red no deja cambios locales ni duplicados', () async {
    final api = FakeApi();
    final vm = CartViewModel(CartRepository(api, signedIn(4)));
    await vm.add(product, 1);
    api.fail = true;
    expect(await vm.change(vm.lines.single, 3), false);
    expect(vm.count, 1);
    expect(await vm.add(product, 5), false);
    expect(vm.count, 1);
    expect(vm.busy, false);
  });
}
