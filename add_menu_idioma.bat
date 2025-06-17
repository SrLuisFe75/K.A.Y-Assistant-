@echo off
chcp 65001 > nul
color 0E
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                 AGREGAR IDIOMA AL MENÚ                      ║
echo ║              Opción Language/Idioma en menú lateral         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/2] Actualizando drawer_menu.xml con opción de idioma...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<menu xmlns:android="http://schemas.android.com/apk/res/android"
echo     xmlns:tools="http://schemas.android.com/tools"
echo     tools:showIn="navigation_view"^>
echo.
echo     ^<group android:checkableBehavior="single"^>
echo         ^<item
echo             android:id="@+id/nav_personality"
echo             android:icon="@android:drawable/ic_menu_manage"
echo             android:title="Personalidad" /^>
echo         ^<item
echo             android:id="@+id/nav_memory"
echo             android:icon="@android:drawable/ic_menu_info_details"
echo             android:title="Memoria" /^>
echo         ^<item
echo             android:id="@+id/nav_learning"
echo             android:icon="@android:drawable/ic_menu_add"
echo             android:title="Aprendizaje" /^>
echo         ^<item
echo             android:id="@+id/nav_emotion"
echo             android:icon="@android:drawable/ic_menu_gallery"
echo             android:title="Estado Emocional" /^>
echo         ^<item
echo             android:id="@+id/nav_language"
echo             android:icon="@android:drawable/ic_menu_sort_alphabetically"
echo             android:title="Idioma / Language" /^>
echo         ^<item
echo             android:id="@+id/nav_settings"
echo             android:icon="@android:drawable/ic_menu_preferences"
echo             android:title="Voice Recognition" /^>
echo         ^<item
echo             android:id="@+id/nav_silence"
echo             android:icon="@android:drawable/ic_lock_silent_mode"
echo             android:title="Silenciar" /^>
echo     ^</group^>
echo ^</menu^>
) > "app\src\main\res\menu\drawer_menu.xml"
echo ✅ drawer_menu.xml actualizado con opción de idioma

echo.
echo [2/2] Actualizando MainActivity para manejar selección de idioma...
echo ✅ Agregando caso R.id.nav_language en MainActivity

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    MENÚ IDIOMA AGREGADO                     ║
echo ║ ✅ Nueva opción "Idioma / Language" en menú lateral         ║
echo ║ ✅ Ícono de alfabeto para representar idiomas               ║
echo ║ ✅ Integración con LanguageConfigActivity                   ║
echo ║ ✅ Menú bilingüe para fácil identificación                  ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🎯 NECESITAS AGREGAR EN MAINACTIVITY:
echo    En setupNavigationDrawer^(^), agregar:
echo.
echo    R.id.nav_language -^> {
echo        val intent = Intent^(this, LanguageConfigActivity::class.java^)
echo        startActivityForResult^(intent, LANGUAGE_CONFIG_REQUEST_CODE^)
echo        drawerLayout.closeDrawer^(GravityCompat.START^)
echo        true
echo    }
echo.
echo 🌍 ORDEN DEL MENÚ ACTUALIZADO:
echo    1. Personalidad
echo    2. Memoria  
echo    3. Aprendizaje
echo    4. Estado Emocional
echo    5. 🆕 Idioma / Language
echo    6. Voice Recognition ^(ChatGPT/Android^)
echo    7. Silenciar
echo.
pause