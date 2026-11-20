# Reto 1: El Recomendador de Películas del Fin de Semana

App Flutter que consume la API de [TMDB](https://www.themoviedb.org/) y recomienda
películas según el estado de ánimo del usuario (Feliz, Triste, Con adrenalina, etc.)
o las tendencias de la semana. Muestra una película destacada con su póster y un
botón "Sorpréndeme" que elige otra al azar.

## Arquitectura

Clean Architecture; la dependencia siempre apunta hacia `domain`.

```
lib/
├── core/
│   ├── config/env.dart            (lee la API key del .env)
│   ├── constants/api_constants.dart
│   └── error/                     (exceptions.dart, failures.dart)
├── features/movies/
│   ├── domain/    entities (Movie, Mood) · repositories · usecases (GetMoviesByMood)
│   ├── data/      datasources (TMDB) · models (MovieModel) · repositories (impl)
│   └── presentation/ providers (MoviesProvider) · pages · widgets
└── main.dart                      (inyección de dependencias)
```

## Configuración

1. Crea una cuenta en TMDB y copia tu **API Key (v3)** desde
   Configuración > API.
2. Abre el archivo `.env` y pega la llave:
   ```
   TMDB_API_KEY=tu_llave_aqui
   ```
   El archivo `.env` está en `.gitignore`. Antes de subir el repo comprueba que
   `.gitignore` contenga la línea `.env` para no publicar tu llave.
   Si lo prefieres, parte de `.env.example`.

## Cómo ejecutarlo

```bash
flutter create . --project-name reto1_recomendador_peliculas --platforms=android,ios,windows,web
flutter pub get
flutter test
flutter run -d windows     # o macos / linux / chrome
```

En Android agrega el permiso de internet en
`android/app/src/main/AndroidManifest.xml`, arriba de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

## Capturas

_Agrega aquí capturas de la app funcionando._
