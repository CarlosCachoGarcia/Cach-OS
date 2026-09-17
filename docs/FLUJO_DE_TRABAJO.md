# Flujo de ramas y procedencia

Se organiza la versión final de Tienda Aula, procedente de `D4N0-D0T/tienda-aula-flutter` (commit `8507677`), sobre el commit inicial `9085f02` de Cach-OS. Este historial registra una **reorganización actual de código previamente construido**, no evidencia de sprints realizados en fechas anteriores.

## Ramas

- `main`: entrega final que superó los controles documentados de esta integración.
- `qa`: candidato con pruebas automatizadas y resultados documentados. No implica validación manual en todos los dispositivos.
- `dev`: integración del desarrollo del sprint.
- `sprint-1`: integración secuencial de las doce historias.
- `feature/usXX-descripcion`: incremento de una historia con código, alcance y criterios de aceptación.

Cada historia se crea desde el estado integrado de `sprint-1` y vuelve a integrarse mediante un merge explícito, sin eliminar su rama. Las historias posteriores incluyen las anteriores porque existen dependencias funcionales. Al finalizar se promueve `sprint-1 → dev → qa → main` con merges explícitos.

No se reescribe el commit inicial, no se fuerza ningún push y no se modifica la fecha ni la autoría para simular un desarrollo pasado. Las ramas documentan integración real; los merges locales no se presentan como revisiones ni aprobaciones de otras personas.

## Para continuar el desarrollo

Crea nuevas ramas desde `dev`; documenta alcance y aceptación; verifica los cambios; integra el siguiente sprint y promueve el candidato a `qa`. Publica en `main` después de revisar sus resultados. No subas SDK, cachés, claves privadas ni configuraciones locales.
