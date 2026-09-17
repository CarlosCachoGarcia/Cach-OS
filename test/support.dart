import 'dart:convert';

import 'package:tienda_aula/core/api_client.dart';
import 'package:tienda_aula/core/session_storage.dart';
import 'package:tienda_aula/core/session.dart';
import 'package:tienda_aula/models/app_user.dart';
import 'package:tienda_aula/models/product.dart';

const product = Product(
  id: 1,
  title: 'Mochila',
  price: 19.99,
  description: 'Para clase',
  category: 'Accesorios',
  image: 'https://example.com/bag.jpg',
);
String tokenFor(int id) => 'header.${base64Url.encode(utf8.encode(jsonEncode({
          'sub': id
        })))}.signature';

class FakeApi implements ApiClient {
  final List<String> calls = [];
  bool fail = false;
  int userId = 4;
  @override
  Future<dynamic> request(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    calls.add('$method $path');
    if (fail) throw Exception('network');
    if (path == '/auth/login') return {'token': tokenFor(userId)};
    if (path.startsWith('/users/')) {
      return {'id': userId, 'username': 'student'};
    }
    if (path == '/users') {
      return [
        {
          'id': 1,
          'username': 'admin',
          'name': {'firstname': 'Ana', 'lastname': 'Pérez'},
          'email': 'ana@example.com',
          'phone': '123',
        },
      ];
    }
    if (path == '/products/categories') return ['Accesorios'];
    if (path == '/products' && method == 'GET' ||
        path.startsWith('/products/category/')) {
      return [
        {'id': 1, ...product.toJson()},
      ];
    }
    if (path.startsWith('/products')) {
      return {'id': 1, ...product.toJson(), ...?body};
    }
    if (path == '/carts' && method == 'GET') {
      return [
        {
          'id': 1,
          'userId': 4,
          'date': '2026-09-13',
          'products': [
            {'productId': 1, 'quantity': 2},
          ],
        },
      ];
    }
    return {'id': 11};
  }
}

class MemoryStorage implements SessionStorage {
  String? token;
  @override
  Future<String?> readToken() async => token;
  @override
  Future<void> save(String value) async {
    token = value;
  }

  @override
  Future<void> clear() async {
    token = null;
  }
}

Session signedIn(int id) =>
    Session()..start(AppUser(id: id, username: 'demo'), tokenFor(id));
