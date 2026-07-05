# EcoMarket - práctica Android nativa

Aplicación de comercio sostenible que reúne los contenidos de INSOD: Kotlin,
Activity, fragments, Navigation Component, View Binding, formularios,
RecyclerView, adaptación a orientación, Volley, Gson, Glide, Snackbar y una
capa preparada para Firebase.

## Ejecutar

1. Abre esta carpeta en Android Studio.
2. Sincroniza Gradle y usa SDK 35 o superior.
3. Inicia un AVD reciente y pulsa **Run**.
4. Usuario de demostración: `admin@ecomarket.es` / `admin`.

El catálogo se obtiene de `https://dummyjson.com/products`. Si no hay red se
muestra un catálogo local para que la práctica siga siendo demostrable.

## Firebase opcional

`FirebaseAuthGateway.kt` encapsula Authentication y Realtime Database siguiendo
el Tema 6. Para activarlo, añade tu `google-services.json`, aplica el plugin
`com.google.gms.google-services` y cambia el gateway en `AppContainer`.
Se deja desactivado por defecto para no publicar credenciales ni impedir que el
proyecto compile en otro equipo.

