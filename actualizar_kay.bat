@echo off
chcp 65001 > nul
color 0A
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    K.A.Y. ASSISTANT UPDATER                 ║
echo ║                     Actualización Segura                    ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

set "PROJECT_DIR=%CD%"
set "BACKUP_DIR=%CD%_BACKUP_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%"

echo [1/6] Creando backup completo...
echo.
xcopy "%PROJECT_DIR%" "%BACKUP_DIR%" /E /I /Y /Q > nul 2>&1
if errorlevel 1 (
    echo ❌ Error al crear backup
    pause
    exit /b 1
)
echo ✅ Backup creado en: %BACKUP_DIR%
echo.

echo [2/6] Creando carpeta assets...
if not exist "app\src\main\assets" mkdir "app\src\main\assets"
echo ✅ Carpeta assets lista
echo.

echo [3/6] Creando carpeta menu...
if not exist "app\src\main\res\menu" mkdir "app\src\main\res\menu"
echo ✅ Carpeta menu lista
echo.

echo [4/6] Actualizando AndroidManifest.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"
echo     xmlns:tools="http://schemas.android.com/tools"^>
echo.
echo     ^<uses-permission android:name="android.permission.INTERNET" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /^>
echo     ^<uses-permission android:name="android.permission.RECORD_AUDIO" /^>
echo     ^<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" /^>
echo     ^<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /^>
echo     ^<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" /^>
echo     ^<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" /^>
echo     ^<uses-permission android:name="android.permission.WRITE_SETTINGS" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" /^>
echo     ^<uses-permission android:name="android.permission.WAKE_LOCK" /^>
echo     ^<uses-permission android:name="android.permission.FOREGROUND_SERVICE" /^>
echo     ^<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" /^>
echo     ^<uses-permission android:name="android.permission.POST_NOTIFICATIONS" /^>
echo.
echo     ^<application
echo         android:allowBackup="true"
echo         android:dataExtractionRules="@xml/data_extraction_rules"
echo         android:fullBackupContent="@xml/backup_rules"
echo         android:icon="@mipmap/ic_launcher"
echo         android:label="@string/app_name"
echo         android:roundIcon="@mipmap/ic_launcher_round"
echo         android:supportsRtl="true"
echo         android:theme="@style/Theme.KAYAssistant"
echo         tools:targetApi="34"^>
echo.        
echo         ^<activity
echo             android:name=".MainActivity"
echo             android:exported="true"
echo             android:theme="@style/Theme.KAYAssistant.NoActionBar"^>
echo             ^<intent-filter^>
echo                 ^<action android:name="android.intent.action.MAIN" /^>
echo                 ^<category android:name="android.intent.category.LAUNCHER" /^>
echo             ^</intent-filter^>
echo         ^</activity^>
echo.
echo         ^<service
echo             android:name=".services.VoiceService"
echo             android:enabled="true"
echo             android:exported="false"
echo             android:foregroundServiceType="microphone"/^>
echo     ^</application^>
echo.
echo ^</manifest^>
) > "app\src\main\AndroidManifest.xml"
echo ✅ AndroidManifest.xml actualizado
echo.

echo [5/6] Creando drawer_menu.xml...
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
echo             android:icon="@android:drawable/ic_menu_mood"
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
echo ✅ drawer_menu.xml creado
echo.

echo [6/6] Script completado - Archivos restantes se crearán en siguiente fase...
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                        RESUMEN                               ║
echo ║ ✅ Backup creado: %BACKUP_DIR%          ║
echo ║ ✅ AndroidManifest.xml actualizado                           ║
echo ║ ✅ drawer_menu.xml creado                                    ║
echo ║ ✅ Carpetas assets y menu creadas                            ║
echo ║                                                              ║
echo ║ 🔧 SIGUIENTE: Ejecutar fase_2_archivos.bat                  ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo Presiona cualquier tecla para continuar...
pause > nul