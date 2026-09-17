# Trazabilidad y revisión manual

Las carpetas DOCX fueron tratadas como especificaciones funcionales. El archivo vacío `US-001_Template.docx` no añade requisitos.

| Historia | Implementación principal | Qué demostrar |
|---|---|---|
| US01 Login y roles | autenticacion, AuthRepository, Session, SecureSessionStorage | Login real, mapeo 1/2/3/resto, error rojo, modo avión antes de HTTP, token seguro. |
| US02 Logout | AuthRepository, CatalogScreen, CartViewModel | Credenciales y memoria vacías, login sin historial anterior. |
| US03 Catálogo | CatalogScreen, CatalogViewModel, Product | Imagen, título, precio, carga, error y reintento; GridView.builder. |
| US04 Categorías | CatalogViewModel, ProductRepository | GET categorías, filtro con URL codificada y regreso a GET general. |
| US05 Detalle | DetailScreen, DetailViewModel | GET por ID, datos completos, acciones por rol, error y retorno. |
| US06 Crear | ProductFormScreen y ViewModel | Validar todos los campos, POST, ID recibido, limpiar formulario, bloqueo por rol. |
| US07 Editar | ProductFormScreen, ProductRepository | Datos precargados, PUT, detalle actualizado, guardado deshabilitado. |
| US08 Eliminar | DetailScreen, ProductRepository | Confirmación, cancelar sin HTTP, DELETE y regreso al catálogo. |
| US09 Agregar | CartViewModel, CartRepository | Cantidad positiva, POST, suma de duplicados, cliente exclusivamente. |
| US10 Carrito | CartScreen, CartViewModel | Total, PUT, DELETE, eliminación al llegar a cero, estado vacío. |
| US11 Usuarios | UsersScreen, AuditRepository, AppUser/Address | Nombre, usuario, correo, teléfono y dirección anidada; bloqueo cliente. |
| US12 Histórico | HistoryScreen, AuditViewModel, CartRecord | ID, fecha, propietario, desglose, títulos cruzados, solo lectura. |

## Recorrido manual de aceptación

1. Iniciar con credenciales erróneas: comprobar mensaje rojo «Usuario o contraseña inválidos».
2. En móvil activar modo avión y probar login: comprobar aviso sin conexión. Desactivarlo y reintentar.
3. Entrar como cliente (tabla en README). Comprobar catálogo, imagen, precio y categorías.
4. Cambiar categoría: ver indicador y únicamente productos del filtro. Elegir «Ver todos».
5. Abrir un artículo: comprobar toda la información y ausencia de editar/eliminar.
6. Agregar cantidad 2 y volver a agregar 1. Abrir carrito: una fila y cantidad 3.
7. Aumentar, disminuir y eliminar. Comprobar total a dos decimales y pago deshabilitado al quedar vacío.
8. Con artículos en el carrito, interrumpir conexión al modificar. Comprobar mensaje y reversión al estado anterior.
9. Cerrar sesión y pulsar Atrás: no volver al catálogo. Entrar con otra cuenta: carrito vacío.
10. Entrar como administrador. Crear con campos vacíos, precio alfabético y URL inválida: debe bloquearse localmente.
11. Crear con campos válidos: comprobar ID y formulario limpio; explicar por qué GET no incluye el nuevo producto.
12. Editar un producto existente: comprobar campos precargados, indicador y cambio en detalle.
13. Pulsar eliminar y cancelar; luego confirmar: mensaje y regreso. Explicar persistencia simulada.
14. Entrar como auditor. Comprobar ausencia de crear/editar/eliminar/agregar al carrito.
15. Abrir usuarios y expandir. Abrir histórico y expandir un carrito: mostrar IDs, cantidades y títulos.
16. Intentar rutas `/product/new`, `/users` y `/history` como cliente: las no permitidas deben mostrar catálogo.
17. Cerrar y reabrir aplicación: recuperar sesión mediante token seguro. Carrito reinicia vacío.
18. Simular error de consulta de detalle: mostrar «Producto no disponible» y volver al catálogo.

## Pruebas automatizadas

`business_test.dart` comprueba roles, sesión, permisos antes de red, validadores, filtrado, cantidades, centavos, eliminación y reversión de fallos. `api_test.dart` comprueba falta de conexión, 401 y errores de respuesta. `screens_test.dart` comprueba validación visual, rutas restringidas, cierre de sesión sin retroceso y pago deshabilitado. Son pruebas con respuestas controladas, no certifican disponibilidad futura del servicio público.
