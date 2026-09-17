# Sprint 1 · Organización de las historias US01–US12

Objetivo: integrar la tienda educativa Flutter con Fake Store API, perfiles locales y estructura MVVM sencilla.

| Historia | Rama | Dependencias | Alcance |
|---|---|---|---|
| US01 | feature/us01-autenticacion | Base | Login, ID, rol, conexión y token seguro |
| US02 | feature/us02-cierre-sesion | US01 | Borrar sesión y bloquear retroceso |
| US03 | feature/us03-catalogo | US01 | GET productos, imagen, título, precio, carga y error |
| US04 | feature/us04-categorias | US03 | Categorías, filtro remoto y ver todos |
| US05 | feature/us05-detalle | US03 | GET individual, detalle y manejo de error |
| US06 | feature/us06-crear-producto | US05 | Formulario, validaciones, POST y permiso administrador |
| US07 | feature/us07-editar-producto | US06 | Precarga, PUT y actualización visual |
| US08 | feature/us08-eliminar-producto | US05 | Confirmación, DELETE y permisos |
| US09 | feature/us09-agregar-carrito | US05 | Cantidades, POST, duplicados y estado local |
| US10 | feature/us10-gestionar-carrito | US09 | Vista, PUT, DELETE, total y estado vacío |
| US11 | feature/us11-usuarios | US01 | Directorio de usuarios, permisos y dirección anidada |
| US12 | feature/us12-historico-carritos | US03, US11 | Histórico global, desglose y cruce con catálogo |

## Criterio de finalización

- Las historias incluyen cambios funcionales, no únicamente ramas vacías.
- La aplicación final conserva el código fuente entregado y sus pruebas.
- Análisis, pruebas y compilación documentados en QA.
- `main` incluye instrucciones de ejecución y glosario.
- Se distingue lo comprobado automáticamente de lo pendiente de comprobar en un teléfono.

La limpieza de carrito de US02 se conecta cuando existe ese estado local en US09; los botones de gestión anunciados en US05 se completan con US06–US08.
