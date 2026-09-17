# Glosario y guía para explicar el proyecto

## Explicación de un minuto

«Mi aplicación es una tienda de práctica hecha con Flutter. Consume Fake Store API para autenticar, consultar productos, simular cambios de inventario y trabajar con carritos. Tiene tres roles. Organicé el código en MVVM y separé cada pantalla en su propio archivo. Las vistas muestran información; los ViewModels controlan las acciones y el estado; los repositorios acceden a la API. El carrito se mantiene localmente porque la API no guarda las modificaciones».

## Qué significa cada término

| Concepto | Explicación sencilla | Ejemplo del proyecto |
|---|---|---|
| Flutter | Herramienta para construir interfaces con Dart. | `main.dart` inicia la aplicación. |
| Dart | Lenguaje en el que están escritas las clases. | `Product`, `Session`, `CartViewModel`. |
| Clase | Molde con datos y comportamientos. | `Product` describe un producto. |
| Objeto | Una instancia concreta de una clase. | Una mochila con ID 1 y precio 19.99. |
| Constructor | Inicializa un objeto y recibe sus dependencias. | `ProductRepository(api, session)`. |
| POO | Organizar un programa mediante objetos con responsabilidades. | Usuarios, productos y carritos tienen clases diferentes. |
| Encapsulación | Controlar cómo se modifica el estado. | `_lines` es privado y se modifica con métodos del carrito. |
| Inmutabilidad | Un objeto conserva sus datos; para cambiarlo se crea otro. | `CartLine` tiene campos `final`. |
| Interfaz | Contrato que indica qué métodos debe cumplir una clase. | `ApiClient` y `SessionStorage`. |
| Implementación | Clase que cumple un contrato. | `HttpApiClient` implementa `ApiClient`. |
| Herencia | Compartir comportamiento desde una clase base. | Los ViewModels extienden `BaseViewModel`. |
| Polimorfismo | Usar implementaciones diferentes mediante el mismo contrato. | HTTP real en la app, `FakeApi` en pruebas. |
| MVVM | Modelo, Vista y ViewModel. | `Product`, `DetailScreen`, `DetailViewModel`. |
| Modelo | Representación de los datos. | `AppUser` incluye un objeto `Address`. |
| Vista | Pantalla que dibuja widgets y recoge interacciones. | `CartScreen` muestra productos y botones. |
| ViewModel | Estado y acciones que necesita una vista. | `CatalogViewModel` expone productos, carga y error. |
| Repositorio | Punto de acceso a datos de un tema. | `AuditRepository` consulta usuarios y carritos. |
| Servicio | Comunicación con algo externo. | `HttpApiClient` envía peticiones HTTP. |
| Widget | Pieza de la interfaz. | `Text`, `Card`, `ListView`, `ProductImage`. |
| StatelessWidget | Widget sin estado mutable propio. | `CartScreen` escucha un ViewModel externo. |
| StatefulWidget | Widget con estado local y ciclo de vida. | El login mantiene controladores de texto. |
| ChangeNotifier | Avisa que un estado cambió. | `notifyListeners()` permite redibujar. |
| ListenableBuilder | Reconstruye la interfaz cuando recibe un aviso. | Actualiza el total del carrito. |
| Future | Resultado de una operación que termina más tarde. | Una consulta de productos. |
| async / await | Permiten esperar resultados sin bloquear la interfaz. | `await repository.list()`. |
| JSON | Formato de datos que responde la API. | `Product.fromJson` convierte un mapa en objeto. |
| Endpoint | Ruta concreta de un servicio. | `/products/categories`. |
| GET | Consultar datos. | Descargar catálogo. |
| POST | Enviar una creación. | Simular un producto o carrito nuevo. |
| PUT | Enviar una actualización. | Editar precio o cantidades. |
| DELETE | Solicitar eliminación. | Simular borrado de producto. |
| Token | Credencial devuelta por el login. | Se conserva en almacenamiento seguro. |
| JWT | Token con información codificada en segmentos. | `sub` permite obtener el ID. Decodificar no verifica una firma. |
| Rol | Perfil que determina acciones permitidas. | Admin, cliente o auditor. |
| Ruta | Destino de navegación. | `/users` está restringida. |
| Validación | Comprobar datos antes de enviarlos. | Evitar precios negativos o URL inválida. |
| Estado de carga | Señal de que una operación sigue pendiente. | `busy` activa un indicador y deshabilita acciones. |
| Excepción | Fallo que puede capturarse y convertirse en mensaje. | `AppError` presenta un texto comprensible. |
| Inyección de dependencias | Recibir colaboradores por constructor. | Un repositorio recibe `ApiClient`. |
| Mock / fake | Sustituto controlado para probar sin internet. | `FakeApi` devuelve respuestas conocidas. |
| Null safety | Diferenciar valores obligatorios y opcionales. | `AppUser?` puede estar vacío sin sesión. |
| dispose | Liberar recursos al abandonar una pantalla. | Se liberan controladores y ViewModels. |

## SOLID aplicado, sin complicarlo

1. **S — Responsabilidad única.** La pantalla del formulario dibuja campos; `ProductFormViewModel` valida y coordina guardar; `ProductRepository` consume los endpoints de productos. Cada clase tiene un motivo claro para cambiar.
2. **O — Abierto a extensión.** Se puede añadir otra implementación de `ApiClient` sin reescribir los ViewModels. Las pruebas aprovechan esta posibilidad.
3. **L — Sustitución de Liskov.** `HttpApiClient` y `FakeApi` cumplen el mismo contrato: devolver un resultado asíncrono o un error. Los consumidores no necesitan cambiar al sustituirlos.
4. **I — Segregación de interfaces.** `SessionStorage` solo define leer, guardar y borrar credenciales; no obliga a implementar productos ni carritos. Los repositorios se dividen por tema.
5. **D — Inversión de dependencias.** Los repositorios reciben la abstracción `ApiClient`, y autenticación recibe `SessionStorage`. La construcción concreta vive en `Dependencies`. Para mantener sencillez, los ViewModels reciben repositorios concretos; no se inventó una interfaz por cada clase.

## Archivos que conviene abrir ante el profesor

1. `lib/main.dart`: prepara Flutter y crea la app.
2. `lib/core/dependencies.dart`: construye y conecta objetos una vez.
3. `lib/models/product.dart`: muestra atributos, constructor y conversión JSON.
4. `lib/features/catalogo/catalog_screen.dart`: muestra una vista con listado reciclable.
5. `lib/features/catalogo/catalog_view_model.dart`: explica carga, filtro y datos.
6. `lib/repositories/product_repository.dart`: muestra GET/POST/PUT/DELETE y permisos.
7. `lib/core/api_client.dart`: explica conexión, espera máxima y errores.
8. `lib/features/compras/cart_view_model.dart`: demuestra reglas y totales locales.
9. `lib/app.dart`: muestra las rutas restringidas por rol.
10. `test/business_test.dart`: demuestra que las reglas se pueden comprobar sin tocar la interfaz.

## Ejemplo completo: agregar al carrito

El cliente toca el botón en `DetailScreen`. La vista llama `CartViewModel.add(product, quantity)`. El ViewModel prepara una nueva lista y suma si ya existe ese ID. `CartRepository` comprueba que la sesión sea de cliente y envía POST `/carts`. Si el servidor responde, se guarda la lista en memoria y se avisa a la interfaz. Si falla, el carrito conserva su estado anterior. El total se calcula con centavos enteros para reducir errores de decimales.

## Ejemplo completo: cerrar sesión

`CatalogScreen` solicita cerrar sesión a `AuthViewModel`. El repositorio elimina las credenciales del almacenamiento seguro y vacía el objeto `Session`. Después se limpia el carrito y se usa `pushNamedAndRemoveUntil` para abrir el login eliminando las rutas anteriores. Por eso «Atrás» no permite volver al catálogo.

## Guion de exposición de 8–10 minutos

- **Minuto 1:** objetivo, API externa y tres roles.
- **Minutos 2–3:** carpetas, POO y el recorrido Vista → ViewModel → Repositorio → API.
- **Minutos 4–5:** iniciar como cliente, filtrar, ver detalle, agregar dos veces y cambiar cantidades.
- **Minutos 6–7:** cerrar sesión; entrar como administrador, crear, editar y cancelar una eliminación; explicar la simulación.
- **Minuto 8:** entrar como auditor y expandir usuarios y carritos. Mostrar que no tiene botones de escritura.
- **Minutos 9–10:** presentar dos principios SOLID con ejemplos y ejecutar pruebas.

## Preguntas probables

**¿Por qué no pusiste todo en main.dart?** Porque mezclar interfaz, peticiones y reglas hace difícil mantener y explicar el código.

**¿Por qué el producto eliminado vuelve a aparecer?** Porque Fake Store API devuelve una respuesta simulada y no modifica su base de datos.

**¿Por qué el carrito sí refleja los cambios?** Porque el estado del carrito se mantiene en nuestra memoria local durante la ejecución.

**¿Qué pasa si se cierra completamente la app?** El token seguro permite recuperar la sesión; el carrito de esta versión comienza vacío.

**¿Dónde se decide el rol?** En `roleFor`, según el ID recibido: 1/2 admin, 3 auditor, el resto cliente.

**¿Basta con esconder botones?** No. También se revisa el rol al navegar y antes de enviar operaciones desde los repositorios.

**¿Es seguridad suficiente para una tienda real?** No: son roles locales para el ejercicio. Un backend real debe verificar permisos y tokens en el servidor.

**¿Por qué usaste ChangeNotifier?** Porque ofrece un mecanismo sencillo de avisos incluido en Flutter, sin una biblioteca adicional de estado.

**¿El pago cobra dinero?** No. Solo presenta el total como demostración, sin procesar pagos.
