import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tienda_aula/core/api_client.dart';

void main() {
  test('US01: sin conexión se detiene antes de enviar HTTP', () async {
    var calls = 0;
    final api = HttpApiClient(
      MockClient((r) async {
        calls++;
        return http.Response('{}', 200);
      }),
      online: () async => false,
    );
    await expectLater(
      api.request('POST', '/auth/login'),
      throwsA(predicate((e) => e.toString().contains('Sin conexión'))),
    );
    expect(calls, 0);
  });
  test('US01: credenciales inválidas muestran mensaje específico', () async {
    final api = HttpApiClient(
      MockClient((r) async => http.Response('invalid', 401)),
      online: () async => true,
    );
    await expectLater(
      api.request('POST', '/auth/login'),
      throwsA(
        predicate((e) => e.toString() == 'Usuario o contraseña inválidos'),
      ),
    );
  });
  test('Errores de servidor y JSON no dejan excepciones crudas', () async {
    for (final response in [
      http.Response('broken', 200),
      http.Response('down', 503),
    ]) {
      final api = HttpApiClient(
        MockClient((r) async => response),
        online: () async => true,
      );
      await expectLater(api.request('GET', '/products'), throwsException);
    }
  });
}
