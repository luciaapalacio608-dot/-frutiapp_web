# FrutiApp Web

Aplicación Flutter Web desarrollada para el curso IF0009 - Desarrollo de Software IV
(Sede del Sur, II Ciclo 2026, Mag. Pablo Noguera Espinoza).

## Descripción

FrutiApp Web es un catálogo de frutas con pantalla de acceso (login) y un catálogo
que consume datos desde una API pública. El proyecto ha evolucionado semana a semana
integrando distintos conceptos de persistencia y consumo de datos.

## Pantallas

- **Login** (`login_screen.dart`): formulario de correo y contraseña con validación.
  Cada intento de acceso (válido o no) queda registrado en la bitácora de accesos.
- **Catálogo** (`home_screen.dart`): lista de productos obtenida vía HTTP desde
  `jsonplaceholder.typicode.com`.
- **Bitácora de accesos** (`bitacora_screen.dart`): pantalla nueva de esta semana.
  Muestra el historial de intentos de acceso y permite exportar/importar esa
  información como archivo JSON.

## Bitácora de accesos (Semana 04)

Se agregó un sistema de bitácora que registra cada intento de acceso con:
- Usuario (correo ingresado)
- Fecha y hora del intento
- Resultado (éxito o fallo)

**Restricción de seguridad:** la bitácora nunca guarda contraseñas, tokens ni
ningún dato sensible — solo lo mínimo necesario para auditar los accesos.

### Estructura del código

- `lib/models/access_record.dart`: modelo de datos `AccessRecord`, con serialización
  a/desde JSON (`toJson` / `fromJson`).
- `lib/services/access_log_service.dart`: servicio `AccessLogService` que administra
  la colección de registros en memoria y su conversión a/desde JSON.
- `lib/screens/bitacora_screen.dart`: interfaz para visualizar los registros y los
  botones de exportar/importar.

### Exportar / Importar JSON

Como Flutter Web no permite escritura directa de archivos con `dart:io`, la
exportación se implementa generando una descarga desde el navegador
(`package:web`), y la importación usa `package:file_selector` para abrir el
selector de archivos nativo del navegador.

## Dependencias agregadas esta semana

```bash
flutter pub add file_selector
flutter pub add web
```

## Cómo correr el proyecto

```bash
flutter pub get
flutter run -d chrome
```
