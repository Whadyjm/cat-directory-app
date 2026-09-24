# 🐱 Cat Directory App

> **Prueba Técnica — Nextep Innovation** | Mobile Developer  
> **Stack:** Flutter (Material 3) • Clean Architecture • BLoC / Cubit • Hive • GoRouter  
> **Calidad:** 38/38 Pruebas Unitarias Aprobadas (100%) • 0 incidencias en `flutter analyze`

---

## 📱 Descripción

Aplicación móvil que consume la API pública de [Catfact Ninja](https://catfact.ninja/) para consultar un catálogo interactivo de razas felinas, detalles taxonómicos y datos curiosos, diseñada con enfoque **Offline-First**, arquitectura limpia y alto rendimiento visual.

---

## 🏛 Arquitectura y Estructura

Se implementó **Clean Architecture** orientada a funcionalidades (**Feature-Driven**):

```
lib/
├── core/         # Inyección (AppInjector), Red (Dio), Router (GoRouter), Tema e Idioma
└── features/
    ├── breeds/    # data (models/datasources/repo) | domain (entities/usecases) | presentation (bloc/pages)
    ├── cat_fact/  # data (api/traducción) | domain | presentation (cubit/widget)
    └── favorites/ # data (hive) | domain | presentation (cubit/page)
```

- **Domain:** Lógica de negocio pura (entidades y casos de uso ejecutables) independiente de frameworks.
- **Data:** Implementación de repositorios, datasources remotos/locales y serialización fuertemente tipada (`freezed`).
- **Presentation:** Widgets desacoplados de la lógica de negocio mediante el patrón BLoC/Cubit.

---

## ⚡ Gestor de Estado: BLoC & Cubit

Se utilizó `flutter_bloc` combinando **BLoC** y **Cubit** según la necesidad del flujo:

- **`BreedsBloc` (Paginación y Búsqueda Concurrente):**
  - `droppable()` (`bloc_concurrency`): Descarta solicitudes de red simultáneas durante el scroll infinito rápido, evitando condiciones de carrera y datos duplicados.
  - `debounce(350ms)` (`stream_transform`): Espera a que el usuario termine de tipear en el buscador local antes de filtrar, manteniendo el hilo de UI a 60/120 FPS.
- **`Cubit` (Estados Atómicos y Directos):**
  - `ThemeCubit`, `LanguageCubit`, `CatFactCubit` y `FavoritesCubit`: Mutaciones sincrónicas y reactivas sin la sobrecarga de eventos innecesarios.

---

## 💾 Persistencia y Modo Offline (Stale-While-Revalidate)

- **Carga Inmediata:** Lee la primera página desde Hive (`breeds_cache`) y la muestra al instante (`isFromCache: true`).
- **Revalidación Asíncrona:** Consulta la API en segundo plano con TTL de 30 minutos y actualiza la lista sin bloquear la interfaz.
- **Ciclo de Vida:** Revalida automáticamente al regresar a primer plano tras permanecer más de 5 minutos en background (`WidgetsBindingObserver`).

---

## ✨ Funcionalidades Clave

- **Directorio (`/`):** Infinite scroll, pull-to-refresh, búsqueda local con debounce, botón flotante "volver arriba" y skeleton shimmer.
- **Filtros Rápidos & Banderas:** Chips por longitud de pelaje (*Corto, Largo, Medio, etc.*) y emojis de banderas según el país de origen.
- **Detalle (`/breed/:name`):** Ficha técnica completa, Hero animations y dato curioso con carga independiente y traducción al español.
- **Favoritos Offline (`/favorites`):** Persistencia en Hive, alternancia en tarjetas y detalle con `SnackBar`, y contador en la barra superior.
- **Deep Linking Nativo:** Android App Links (`assetlinks.json`) e iOS Universal Links (`apple-app-site-association`).
- **Modos y Temas:** Claro / Oscuro / Sistema y selector bilingüe (Español / Inglés).

---

## 📊 Auditoría de Rendimiento

- **Scroll a 60 / 120 FPS:** Renderizado fluido verificado con `PerformanceOverlay` mediante `ListView.builder`, widgets `const` y aislamiento de repintado.
- **Análisis de Tamaño (`flutter build apk --target-platform android-arm64 --analyze-size`):**
  - **APK comprimido:** **`7.4 MB`** (`app-release.apk`).
  - **Código de la app (`package:cat_directory_app`):** Solo **`90 KB`** (alta modularidad y optimización).
  - **Tree-Shaking de fuentes:** Reducción del 99.6% (`CupertinoIcons`: 1.1 KB, `MaterialIcons`: 4.9 KB).

---

## 🚀 Instalación y Ejecución

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar la app
flutter run

# 3. Correr la suite de pruebas unitarias (38 tests)
flutter test

# 4. Verificación de análisis estático
flutter analyze
```

### Prueba de Deep Link (Android ADB):
```bash
adb shell am start -a android.intent.action.VIEW \
  -c android.intent.category.BROWSABLE \
  -d "https://cat-directory.nextep.com/breed/Abyssinian"
```
