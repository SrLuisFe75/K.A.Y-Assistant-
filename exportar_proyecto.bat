@echo off
chcp 65001 > nul
echo === PROYECTO K.A.Y. ASSISTANT === > proyecto_completo.txt
echo Generado: %date% %time% >> proyecto_completo.txt
echo. >> proyecto_completo.txt

echo === GRADLE PROJECT === >> proyecto_completo.txt
if exist "build.gradle" (
    type "build.gradle" >> proyecto_completo.txt
) else if exist "build.gradle.kts" (
    type "build.gradle.kts" >> proyecto_completo.txt
)
echo. >> proyecto_completo.txt

echo === GRADLE APP === >> proyecto_completo.txt
if exist "app\build.gradle" (
    type "app\build.gradle" >> proyecto_completo.txt
) else if exist "app\build.gradle.kts" (
    type "app\build.gradle.kts" >> proyecto_completo.txt
)
echo. >> proyecto_completo.txt

echo === ANDROID MANIFEST === >> proyecto_completo.txt
if exist "app\src\main\AndroidManifest.xml" (
    type "app\src\main\AndroidManifest.xml" >> proyecto_completo.txt
)
echo. >> proyecto_completo.txt

echo === ACTIVITIES === >> proyecto_completo.txt
for /r "app\src\main\java" %%f in (*.java *.kt) do (
    echo --- %%~nxf --- >> proyecto_completo.txt
    type "%%f" >> proyecto_completo.txt
    echo. >> proyecto_completo.txt
)

echo === LAYOUTS === >> proyecto_completo.txt
for /r "app\src\main\res\layout" %%f in (*.xml) do (
    echo --- %%~nxf --- >> proyecto_completo.txt
    type "%%f" >> proyecto_completo.txt
    echo. >> proyecto_completo.txt
)

echo === VALORES === >> proyecto_completo.txt
if exist "app\src\main\res\values\strings.xml" (
    echo --- strings.xml --- >> proyecto_completo.txt
    type "app\src\main\res\values\strings.xml" >> proyecto_completo.txt
)

echo ¡Listo! Archivo proyecto_completo.txt generado
pause