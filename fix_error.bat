@echo off
chcp 65001 > nul
color 0C
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    ARREGLAR ERROR ICONOS                    ║
echo ║              Corrigiendo drawer_menu.xml                    ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/1] Actualizando drawer_menu.xml con iconos compatibles...
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
echo             android:id="@+id/nav_settings"
echo             android:icon="@android:drawable/ic_menu_preferences"
echo             android:title="Configuración" /^>
echo         ^<item
echo             android:id="@+id/nav_silence"
echo             android:icon="@android:drawable/ic_lock_silent_mode"
echo             android:title="Silenciar" /^>
echo     ^</group^>
echo ^</menu^>
) > "app\src\main\res\menu\drawer_menu.xml"
echo ✅ drawer_menu.xml corregido con iconos compatibles
echo.

echo ╔══════════════════════════════════════════════════════════════╗
echo ║                      ERROR SOLUCIONADO                      ║
echo ║ ✅ Cambié ic_menu_mood por ic_menu_gallery                  ║
echo ║ ✅ Ahora todos los iconos son compatibles                   ║
echo ║ ✅ Listo para compilar de nuevo                             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause