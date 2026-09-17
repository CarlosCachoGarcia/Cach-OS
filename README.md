# Cach-OS · Entrega final de Tienda Aula

La aplicación completa está en `main`. [Flujo de ramas](docs/FLUJO_DE_TRABAJO.md) · [Sprint 1](docs/SPRINT_1.md) · [Informe de QA](docs/QA.md).

Este repositorio conserva su commit inicial y añade una reorganización actual de código ya construido, proveniente de [tienda-aula-flutter](https://github.com/D4N0-D0T/tienda-aula-flutter). Cada rama `feature/usXX-*` contiene un incremento y su prueba. El historial no representa fechas ni autorías de un desarrollo pasado.

# Tienda Aula · Flutter

Aplicación educativa que consume **https://fakestoreapi.com**. Incluye las 12 historias recibidas, distribuidas en las cinco épicas. No crea un servidor nuevo: las historias requieren integrar la API pública existente.

Se interpretó «MVVC» como **MVVM: Modelo, Vista y ViewModel**. Se usa programación orientada a objetos, inyección manual de dependencias y principios SOLID sin introducir BLoC, generadores ni capas innecesarias.

## Ejecutar

1. Instala Flutter estable y configura un dispositivo Android o simulador iOS. Revisa `flutter doctor`.
2. Abre esta carpeta (la que contiene `pubspec.yaml`) en VS Code o Android Studio.
3. Ejecuta:

```sh
flutter pub get
flutter run
```

Para navegador:

```sh
flutter run -d chrome
```

El navegador debe permitir las solicitudes a Fake Store API. En web, el almacenamiento seguro requiere localhost o HTTPS. Para la entrega móvil, usa Android o iOS: el plugin guarda el token con mecanismos de almacenamiento seguro del dispositivo.

```sh
flutter analyze
flutter test
flutter build web
```

## Cuentas públicas para la exposición

Estas cuentas son datos de prueba publicados por Fake Store API, no usuarios reales de tu proyecto. Consultadas al preparar la entrega; el servicio externo puede cambiarlas.

| ID | Perfil | Usuario | Contraseña |
|---|---|---|---|
| 1 | Administrador | `johnd` | `m38rmF$` |
| 3 | Auditor | `kevinryan` | `kev02937@` |
| 4 | Cliente | `donero` | `ewedon` |

Los IDs 1 y 2 son administradores; el 3 es auditor; los restantes son clientes. El rol se calcula localmente desde el ID recuperado a partir del token. No se elige con un selector de roles.

## Carpetas

```text
lib/
  main.dart                      Arranque
  app.dart                       Tema y rutas protegidas
  core/                          HTTP, sesión, almacenamiento e inyección
  models/                        Product, AppUser, Address, CartLine, CartRecord
  repositories/                  Acceso a datos y comprobación de permisos
  features/
    autenticacion/               US01–US02
    catalogo/                    US03–US05
    inventario/                  US06–US08
    compras/                     US09–US10
    auditorias/                  US11–US12
  widgets/                       Imagen, errores y mensajes reutilizables
```

Cada pantalla tiene su archivo. Los ViewModels manejan estado y acciones; los repositorios solicitan datos; los modelos representan objetos. `Dependencies` conecta estas clases por constructor.

## Comportamiento de la simulación

- Crear, editar o eliminar consume POST, PUT o DELETE reales, pero Fake Store API **no persiste los cambios**.
- Al crear se informa el ID recibido y se limpia el formulario. El nuevo artículo no aparece en el GET del catálogo.
- Al editar, la respuesta actualiza el detalle abierto; una nueva consulta recupera los datos originales del servidor.
- Al eliminar se confirma antes y se regresa al catálogo. El artículo puede seguir apareciendo, tal como advierte US08.
- El carrito es local en memoria mientras la aplicación está abierta. La sesión segura puede restaurarse al reiniciar, pero el carrito comienza vacío; no se implementó persistencia de compras entre arranques.
- Agregar un producto repetido suma su cantidad. Una operación de red fallida no confirma cambios locales.
- Para remover un artículo se llama DELETE `/carts/{id}` como exige US10. Ese endpoint representa un carrito completo; en esta práctica la eliminación individual se conserva localmente porque la API no persiste.
- El histórico muestra los carritos del servidor, no los creados en la simulación local.
- «Proceder al pago» muestra un resumen de demostración; no hay cobros ni una pasarela real en las historias.
- Solo se guarda el token en almacenamiento seguro. El usuario y el rol se recuperan/calculan al restaurar; no hay una segunda copia persistida de esos campos que pueda quedar desactualizada. Al salir se elimina el almacenamiento, se borra la sesión y el carrito, y se destruye el historial de navegación.
- Los roles locales son la regla académica de las historias. Fake Store API no implementa autorización real por estos roles; en un sistema de producción la autorización tendría que estar también en un servidor propio.

## Guías incluidas

- `GLOSARIO_Y_EXPOSICION.md`: explicación de clases, conceptos, SOLID y guion para presentar.
- `HISTORIAS_Y_PRUEBAS.md`: trazabilidad por historia y recorrido manual de aceptación.
- `VERIFICACION.md`: resultados de verificación y límites comprobados.

## Referencias

- [Arquitectura MVVM en Flutter](https://docs.flutter.dev/app-architecture/guide)
- [Fake Store API](https://fakestoreapi.com/)
- [Código y documentación de Fake Store API](https://github.com/keikaavousi/fake-store-api)
- [Almacenamiento seguro](https://pub.dev/packages/flutter_secure_storage)
