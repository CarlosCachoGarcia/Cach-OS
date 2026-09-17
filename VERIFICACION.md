# Verificación de la entrega

Fecha: 13 de septiembre de 2026.

- Flutter 3.47.4 estable; Dart 3.13.3.
- `flutter analyze`: **No issues found**.
- `flutter test`: **15 pruebas aprobadas**.
- `flutter build web`: **compilación completada**.
- Aplicación web ejecutada en localhost y revisada en navegador: login real de administrador, catálogo con imágenes, detalle con permisos, formulario precargado, actualización de precio de 109.95 a 99.50 reflejada en detalle, menú con rol administrador y cierre de sesión confirmado en login.

## Comprobaciones del servicio real

Se consultaron cuentas públicas y se verificaron estos endpoints mediante un cliente HTTP. Las escrituras son simulaciones propias de Fake Store API.

| Método | Endpoint | Código recibido |
|---|---|---|
| POST | `/auth/login` | 201 |
| POST | `/auth/login` | 201 |
| POST | `/auth/login` | 201 |
| POST | `/auth/login` | 401 |
| GET | `/products` | 200 |
| GET | `/products/categories` | 200 |
| GET | `/products/category/electronics` | 200 |
| GET | `/products/1` | 200 |
| GET | `/users` | 200 |
| GET | `/carts` | 200 |
| POST | `/products` | 201 |
| PUT | `/products/1` | 200 |
| DELETE | `/products/1` | 200 |
| POST | `/carts` | 201 |
| PUT | `/carts/11` | 200 |
| DELETE | `/carts/11` | 200 |

Los tres primeros login corresponden a administrador, auditor y cliente; el cuarto usa credenciales erróneas y devuelve 401. El cliente acepta todos los estados HTTP 2xx: el login del servicio actualmente responde 201 aunque la historia menciona 200.

## Alcance y límites

Las pruebas automáticas usan sustitutos controlados y cubren reglas y algunas pantallas. La revisión del navegador es una comprobación real parcial, no una ejecución manual exhaustiva de cada criterio. El recorrido completo para la clase está en `HISTORIAS_Y_PRUEBAS.md`.

No se ha compilado un APK ni ejecutado la aplicación en un teléfono Android o simulador iOS. Se entregan las carpetas nativas y los permisos Android de internet y estado de red. El almacenamiento nativo seguro requiere su verificación final en el dispositivo elegido.

La compilación web estándar JavaScript funciona. La versión del plugin de almacenamiento seguro usada avisa de incompatibilidad con la compilación WebAssembly; no se usa `--wasm` en esta entrega.

Durante la preparación fue necesario usar los componentes ARM64 de Flutter porque el entorno restringido detectó x64. Es un ajuste del SDK de comprobación, fuera del proyecto entregado.
