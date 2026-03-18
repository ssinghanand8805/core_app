# Flutter Scalable App — Developer Handoff

## Stack
GetX · Dio · Drift (SQLite) · SharedPreferences · connectivity_plus · Fluttertoast

## First Run
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
`build_runner` generates `app_database.g.dart` from Drift table definitions. Re-run it every time you edit `app_database.dart`.

---

## Architecture: Clean Architecture in 3 Layers

```
domain  →  data  →  presentation
```

**domain** — pure Dart, zero Flutter/package imports. Entities, abstract repository contracts, usecases.
**data** — implements domain contracts. Remote (Dio), Local (Drift), Repository (decides which to use).
**presentation** — GetX controllers, pages, widgets. Reads from usecases, never touches Dio or Drift directly.

---

## Offline-First: How It Works

Every repository follows this pattern:

```dart
if (ConnectivityService.to.isConnected) {
  data = await remote.fetch();   // hit API
  await local.cache(data);       // write to SQLite
  return data;
} else {
  return await local.getCached(); // read from SQLite
}
```

Turn off Wi-Fi → app loads cached data → orange `OfflineBanner` appears automatically.
Cache is empty + offline → `CacheException` → `ErrorView` with Retry button.

---

## Error Handling: Typed Exceptions All the Way Down

`ErrorInterceptor` (in `interceptors.dart`) catches every `DioException` and re-throws a typed exception:

```
DioException → NetworkException / ServerException / UnauthorizedException / RequestTimeoutException
```

Controllers catch each type individually and show the right toast:

```dart
} on NetworkException { _showToast(TKeys.networkError.tr, Colors.orange); }
} on UnauthorizedException { _showToast(TKeys.unauthorized.tr, Colors.red); }
```

Never catch bare `Exception` as the first clause — always put specific types first.

---

## Theme
`ThemeService` (GetxService) stores `light/dark/system` in SharedPreferences.
Toggle from anywhere: `ThemeService.to.toggleTheme()`.
`MyApp` is wrapped in `Obx()` so the whole app re-renders on change without restart.

---

## Localization
Keys live in `TKeys` (compile-safe constants). Translations in `l10n/en.dart`, `hi.dart`, `ar.dart`, `ur.dart`.
Switch language: `Get.updateLocale(Locale('hi', 'IN'))` — persisted automatically.
Add a language: create `fr.dart`, add to `AppTranslations.keys`, add `Locale` to `supportedLocales`.

---

## Adding a New Feature (e.g. Comments)
1. `domain/entities/comment_entity.dart` — plain Dart class
2. `domain/repositories/comment_repository.dart` — abstract contract
3. `domain/usecases/get_comments.dart` — single `call()` method
4. `data/models/comment_model.dart` — extends entity, adds `fromJson`
5. `data/datasources/remote/comment_remote_datasource.dart` — Dio call
6. Add `CommentsTable` to `app_database.dart` → re-run `build_runner`
7. `data/datasources/local/comment_local_datasource.dart` — Drift queries
8. `data/repositories/comment_repository_impl.dart` — offline-first logic
9. `presentation/controllers/comment_controller.dart` — typed catch blocks
10. Register in `app_pages.dart` binding → `Get.lazyPut`

---

## Key Files at a Glance
| File | What to edit |
|---|---|
| `core/utils/constants.dart` | Change `baseUrl`, timeouts |
| `core/network/api_endpoints.dart` | Add new endpoints |
| `core/utils/app_theme.dart` | Change colors, fonts |
| `l10n/translation_keys.dart` | Add new string keys |
| `l10n/en.dart` (+ others) | Add translations |
| `routes/app_pages.dart` | Register new screens + bindings |
| `data/datasources/local/app_database.dart` | Add new Drift tables |
