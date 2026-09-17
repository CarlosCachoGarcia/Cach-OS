# QA · Integración final de Cach-OS

Fecha de comprobación: 17 de septiembre de 2026. Flutter 3.47.4 / Dart 3.13.3.

| Control ejecutado | Resultado |
|---|---|
| Análisis de cada incremento US01–US12 | Sin observaciones en cada rama |
| Pruebas acumuladas de cada incremento | Aprobadas antes de su merge al sprint |
| `flutter analyze --no-pub` sobre QA | Sin observaciones |
| `flutter test --no-pub` sobre QA | 27 pruebas aprobadas |
| `flutter build web --no-pub` | Compilación JavaScript completada |
| `flutter build apk --release --no-pub` | APK Android universal generado |
| `apksigner verify` | Firma válida |
| Código de `lib/` comparado con la aplicación final de origen | Coincidencia exacta |

## Cobertura

Doce pruebas específicas, una por historia, más las quince pruebas originales de reglas, API y pantallas. Se comprueban roles, sesión, permisos antes de HTTP, filtros, detalle, validación de formulario, inventario, cantidades, total, reversión ante error, auditoría y cierre sin retroceso.

Las pruebas usan respuestas controladas; no equivalen a disponibilidad permanente de Fake Store API ni a una prueba completa sobre teléfono físico. El recorrido manual sigue documentado en `HISTORIAS_Y_PRUEBAS.md`.

## Android

APK de pruebas, versión 1.0.0, paquete `com.ejemplo.tienda_aula`. Android 7.0/API 24 o superior; ARM 32/64 y x86_64. Compilación release firmada con el certificado de pruebas del entorno. No se sube la clave de firma ni el APK al historial de código.

## Límites conocidos

- Fake Store API simula escrituras; el carrito se mantiene en memoria durante la ejecución.
- La sesión segura se restaura; el carrito no persiste entre arranques.
- No se ha realizado una instalación y recorrido completo en teléfono físico.
- El plugin de almacenamiento seguro no admite la compilación WebAssembly usada en la comprobación exploratoria del SDK; se verificó la compilación web estándar JavaScript.
- La promoción a `main` registra comprobaciones automatizadas; no se atribuye una aprobación humana de QA a terceros.
