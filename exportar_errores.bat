@echo off
chcp 65001 > nul
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   EXPORTAR TODOS LOS ERRORES                ║
echo ║              Para que Claude los pueda revisar              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/1] Exportando errores de compilación...
echo === ERRORES DE COMPILACIÓN K.A.Y. ASSISTANT === > errores_completos.txt
echo Generado: %date% %time% >> errores_completos.txt
echo. >> errores_completos.txt

echo === INSTRUCCIONES === >> errores_completos.txt
echo 1. Ve a Android Studio >> errores_completos.txt
echo 2. Pestaña "Problems" ^(parte inferior^) >> errores_completos.txt
echo 3. Selecciona TODOS los errores ^(Ctrl + A^) >> errores_completos.txt
echo 4. Copia ^(Ctrl + C^) >> errores_completos.txt
echo 5. Pega aquí abajo en este archivo >> errores_completos.txt
echo. >> errores_completos.txt
echo === PEGA AQUÍ LOS ERRORES === >> errores_completos.txt
echo. >> errores_completos.txt
echo. >> errores_completos.txt
echo. >> errores_completos.txt
echo. >> errores_completos.txt

echo ✅ Archivo errores_completos.txt creado
echo.
echo 🎯 AHORA HAZ ESTO:
echo 1. Abre el archivo errores_completos.txt
echo 2. Ve a Android Studio -^> pestaña "Problems" 
echo 3. Selecciona TODOS los errores ^(Ctrl + A^)
echo 4. Copia ^(Ctrl + C^)
echo 5. Pega en errores_completos.txt después de "=== PEGA AQUÍ LOS ERRORES ==="
echo 6. Guarda el archivo
echo 7. Copia todo el contenido del archivo y pégalo en Claude
echo.
pause