import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import 'app_error.dart';

abstract class ApiClient {
  Future<dynamic> request(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]);
}

class HttpApiClient implements ApiClient {
  final http.Client client;
  final Future<bool> Function() online;
  HttpApiClient(this.client, {Future<bool> Function()? online})
      : online = online ??
            (() async => !(await Connectivity().checkConnectivity()).contains(
                  ConnectivityResult.none,
                ));
  @override
  Future<dynamic> request(
    String method,
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    try {
      if (!await online()) {
        throw const AppError(
          'Sin conexión. Revisa tu internet e inténtalo de nuevo.',
        );
      }
      final request = http.Request(
        method,
        Uri.parse('https://fakestoreapi.com$path'),
      );
      request.headers['Content-Type'] = 'application/json';
      if (body != null) request.body = jsonEncode(body);
      final response = await client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 20));
      if (response.statusCode == 401 ||
          (path == '/auth/login' && response.statusCode == 400)) {
        throw const AppError('Usuario o contraseña inválidos');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppError(
          'El servidor no pudo completar la solicitud (${response.statusCode}). Reintenta.',
        );
      }
      return jsonDecode(response.body);
    } on AppError {
      rethrow;
    } on TimeoutException {
      throw const AppError('El servidor tardó demasiado. Reintenta.');
    } on FormatException {
      throw const AppError('El servidor devolvió datos inesperados.');
    } catch (_) {
      throw const AppError(
        'No fue posible conectar con la tienda. Revisa tu conexión.',
      );
    }
  }
}
