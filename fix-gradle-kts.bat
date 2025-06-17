@echo off
setlocal enabledelayedexpansion

:: Ruta base del proyecto
set ROOT=%~dp0
set SETTINGS=%ROOT%settings.gradle.kts
set APPBUILD=%ROOT%app\build.gradle.kts

echo Corrigiendo settings.gradle.kts...
(
echo pluginManagement {
echo     repositories {
echo         google()
echo         gradlePluginPortal()
echo         mavenCentral()
echo     }
echo }
echo.
echo dependencyResolutionManagement {
echo     repositoriesMode.set\(RepositoriesMode.FAIL_ON_PROJECT_REPOS\)
echo     repositories {
echo         google()
echo         mavenCentral()
echo     }
echo }
echo.
echo rootProject.name = "K.A.Y. ASSISTANT"
echo include(":app")
) > "!SETTINGS!"

echo Corrigiendo app\build.gradle.kts...
(
echo plugins {
echo     id("com.android.application") version "8.2.0"
echo     id("org.jetbrains.kotlin.android")
echo     id("com.google.gms.google-services")
echo }
echo.
echo android {
echo     namespace = "com.kay.assistant"
echo     compileSdk = 34
echo.
echo     defaultConfig {
echo         applicationId = "com.kay.assistant"
echo         minSdk = 26
echo         targetSdk = 34
echo         versionCode = 1
echo         versionName = "1.0"
echo         testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
echo     }
echo.
echo     buildTypes {
echo         release {
echo             isMinifyEnabled = false
echo             proguardFiles(
echo                 getDefaultProguardFile("proguard-android-optimize.txt"),
echo                 "proguard-rules.pro"
echo             )
echo         }
echo     }
echo }
) > "!APPBUILD!"

echo ✅ Archivos corregidos exitosamente.
echo 🔄 Por favor, vuelve a sincronizar Gradle en Android Studio.

pause
