@echo off
echo 🔧 Corrigiendo configuración Gradle...

:: Ruta al build.gradle.kts del proyecto raíz
set ROOT_BUILD_FILE="K.A.Y. ASSISTANT\build.gradle.kts"
echo Corrigiendo %ROOT_BUILD_FILE%...
(
echo // build.gradle.kts en el proyecto raíz "K.A.Y. ASSISTANT"
echo.
echo buildscript {
echo     dependencies {
echo         // No es necesario agregar nada aquí por ahora
echo     }
echo }
) > %ROOT_BUILD_FILE%

:: Confirmación
echo ✅ Archivo del proyecto raíz corregido

:: Espera para ver el resultado
pause
