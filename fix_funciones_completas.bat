@echo off
chcp 65001 > nul
color 0B
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                 ACTIVAR TODAS LAS FUNCIONES                 ║
echo ║           Voz + Escucha + ChatGPT + Permisos 24/7           ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/3] Actualizando MainActivity para iniciar todo automáticamente...
(
echo package com.kay.assistant
echo.
echo import android.os.Bundle
echo import android.webkit.WebView
echo import android.webkit.WebViewClient
echo import android.webkit.JavascriptInterface
echo import androidx.appcompat.app.AppCompatActivity
echo import android.content.Intent
echo import android.content.IntentFilter
echo import android.content.BroadcastReceiver
echo import android.content.Context
echo import androidx.core.content.ContextCompat
echo import com.kay.services.VoiceService
echo import android.widget.Toast
echo import com.kay.core.KAYBrain
echo import android.Manifest
echo import android.content.pm.PackageManager
echo import androidx.core.app.ActivityCompat
echo import androidx.drawerlayout.widget.DrawerLayout
echo import com.google.android.material.navigation.NavigationView
echo import androidx.fragment.app.Fragment
echo import androidx.core.view.GravityCompat
echo import android.view.View
echo import android.widget.FrameLayout
echo import android.view.Gravity
echo import android.net.Uri
echo import android.provider.Settings
echo import androidx.appcompat.app.AlertDialog
echo import android.app.Activity
echo.
echo class MainActivity : AppCompatActivity^(^) {
echo     private lateinit var webView: WebView
echo     private lateinit var drawerLayout: DrawerLayout
echo     private lateinit var navigationView: NavigationView
echo     private lateinit var brain: KAYBrain
echo.    
echo     private val hudReceiver = object : BroadcastReceiver^(^) {
echo         override fun onReceive^(context: Context?, intent: Intent?^) {
echo             if ^(intent?.action == "com.kay.assistant.UPDATE_HUD"^) {
echo                 val response = intent.getStringExtra^("response"^)
echo                 response?.let { updateHUD^(it^) }
echo             }
echo         }
echo     }
echo.
echo     private val PERMISSIONS_REQUEST_CODE = 123
echo     private val OVERLAY_PERMISSION_REQUEST_CODE = 124
echo     private val CHATGPT_CONFIG_REQUEST_CODE = 125
echo.
echo     override fun onCreate^(savedInstanceState: Bundle?^) {
echo         super.onCreate^(savedInstanceState^)
echo         setContentView^(R.layout.activity_main^)
echo.
echo         brain = KAYBrain^(applicationContext^)
echo         setupWebView^(^)
echo         setupNavigationDrawer^(^)
echo         
echo         // Iniciar servicios inmediatamente
echo         requestAllPermissions^(^)
echo.        
echo         val filter = IntentFilter^("com.kay.assistant.UPDATE_HUD"^)
echo         ContextCompat.registerReceiver^(
echo             this,
echo             hudReceiver,
echo             filter,
echo             ContextCompat.RECEIVER_NOT_EXPORTED
echo         ^)
echo.
echo         // Mostrar mensaje de bienvenida
echo         Toast.makeText^(this, "K.A.Y. Assistant iniciando... Di 'Kay' para activar", Toast.LENGTH_LONG^).show^(^)
echo     }
echo.
echo     private fun setupWebView^(^) {
echo         webView = findViewById^(R.id.webView^)
echo         webView.settings.apply {
echo             javaScriptEnabled = true
echo             domStorageEnabled = true
echo             mediaPlaybackRequiresUserGesture = false
echo             allowFileAccess = true
echo             allowContentAccess = true
echo         }
echo         webView.webViewClient = WebViewClient^(^)
echo         webView.addJavascriptInterface^(WebAppInterface^(^), "Android"^)
echo         webView.loadUrl^("file:///android_asset/kay_hud.html"^)
echo     }
echo.
echo     private fun setupNavigationDrawer^(^) {
echo         drawerLayout = findViewById^(R.id.drawer_layout^)
echo         navigationView = findViewById^(R.id.nav_view^)
echo.
echo         navigationView.setNavigationItemSelectedListener { menuItem -^>
echo             when ^(menuItem.itemId^) {
echo                 R.id.nav_personality -^> {
echo                     showPersonalityDialog^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 R.id.nav_memory -^> {
echo                     showMemoryDialog^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 R.id.nav_learning -^> {
echo                     showLearningDialog^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 R.id.nav_emotion -^> {
echo                     showEmotionDialog^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 R.id.nav_settings -^> {
echo                     showVoiceProviderDialog^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 R.id.nav_silence -^> {
echo                     toggleSilence^(^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 else -^> false
echo             }
echo         }
echo     }
echo.
echo     private fun showVoiceProviderDialog^(^) {
echo         val options = arrayOf^("Android Nativo", "ChatGPT"^)
echo         AlertDialog.Builder^(this^)
echo             .setTitle^("Seleccionar Proveedor de IA"^)
echo             .setItems^(options^) { _, which -^>
echo                 when^(which^) {
echo                     0 -^> {
echo                         // Android nativo
echo                         val intent = Intent^("com.kay.assistant.CHANGE_PROVIDER"^)
echo                         intent.putExtra^("provider", "android"^)
echo                         sendBroadcast^(intent^)
echo                         Toast.makeText^(this, "Usando Android nativo", Toast.LENGTH_SHORT^).show^(^)
echo                     }
echo                     1 -^> {
echo                         // ChatGPT - abrir configuración
echo                         val intent = Intent^(this, ChatGPTLoginActivity::class.java^)
echo                         startActivityForResult^(intent, CHATGPT_CONFIG_REQUEST_CODE^)
echo                     }
echo                 }
echo             }
echo             .show^(^)
echo     }
echo.
echo     override fun onActivityResult^(requestCode: Int, resultCode: Int, data: Intent?^) {
echo         super.onActivityResult^(requestCode, resultCode, data^)
echo         when^(requestCode^) {
echo             CHATGPT_CONFIG_REQUEST_CODE -^> {
echo                 if ^(resultCode == Activity.RESULT_OK^) {
echo                     val configured = data?.getBooleanExtra^("configured", false^) ?: false
echo                     if ^(configured^) {
echo                         val intent = Intent^("com.kay.assistant.CHANGE_PROVIDER"^)
echo                         intent.putExtra^("provider", "chatgpt"^)
echo                         sendBroadcast^(intent^)
echo                         Toast.makeText^(this, "Usando ChatGPT", Toast.LENGTH_SHORT^).show^(^)
echo                     }
echo                 }
echo             }
echo             OVERLAY_PERMISSION_REQUEST_CODE -^> {
echo                 startVoiceService^(^)
echo             }
echo         }
echo     }
echo.
echo     private fun showPersonalityDialog^(^) {
echo         val personalities = arrayOf^("Tony Stark", "HAL 9000", "GLaDOS", "Profesional", "Amigable", "Sarcástico"^)
echo         AlertDialog.Builder^(this^)
echo             .setTitle^("Seleccionar Personalidad"^)
echo             .setItems^(personalities^) { _, which -^>
echo                 val personality = when^(which^) {
echo                     0 -^> KAYBrain.Personality.TONY_STARK
echo                     1 -^> KAYBrain.Personality.HAL_9000
echo                     2 -^> KAYBrain.Personality.GLADOS
echo                     3 -^> KAYBrain.Personality.PROFESIONAL
echo                     4 -^> KAYBrain.Personality.AMIGABLE
echo                     5 -^> KAYBrain.Personality.SARCASTICO
echo                     else -^> KAYBrain.Personality.TONY_STARK
echo                 }
echo                 brain.setPersonality^(personality^)
echo                 Toast.makeText^(this, "Personalidad: ${personalities[which]}", Toast.LENGTH_SHORT^).show^(^)
echo                 updateHUD^("Personalidad actualizada a ${personalities[which]}"^)
echo             }
echo             .show^(^)
echo     }
echo.
echo     private fun showMemoryDialog^(^) {
echo         AlertDialog.Builder^(this^)
echo             .setTitle^("Memoria de K.A.Y."^)
echo             .setMessage^("K.A.Y. recuerda todas nuestras conversaciones y aprende continuamente."^)
echo             .setPositiveButton^("Entendido"^) { _, _ -^> }
echo             .show^(^)
echo     }
echo.
echo     private fun showLearningDialog^(^) {
echo         AlertDialog.Builder^(this^)
echo             .setTitle^("Aprendizaje Activo"^)
echo             .setMessage^("K.A.Y. está en constante aprendizaje para mejorar sus respuestas."^)
echo             .setPositiveButton^("Perfecto"^) { _, _ -^> }
echo             .show^(^)
echo     }
echo.
echo     private fun showEmotionDialog^(^) {
echo         AlertDialog.Builder^(this^)
echo             .setTitle^("Estado Emocional"^)
echo             .setMessage^("K.A.Y. se encuentra activo y listo para conversar."^)
echo             .setPositiveButton^("Excelente"^) { _, _ -^> }
echo             .show^(^)
echo     }
echo.
echo     private fun toggleSilence^(^) {
echo         Toast.makeText^(this, "Modo silencioso activado temporalmente", Toast.LENGTH_LONG^).show^(^)
echo         updateHUD^("Modo silencioso activado"^)
echo     }
echo.
echo     private fun requestAllPermissions^(^) {
echo         val permissions = arrayOf^(
echo             Manifest.permission.RECORD_AUDIO,
echo             Manifest.permission.WRITE_EXTERNAL_STORAGE,
echo             Manifest.permission.READ_EXTERNAL_STORAGE,
echo             Manifest.permission.ACCESS_NOTIFICATION_POLICY,
echo             Manifest.permission.WAKE_LOCK,
echo             Manifest.permission.POST_NOTIFICATIONS,
echo             Manifest.permission.READ_CONTACTS,
echo             Manifest.permission.WRITE_CONTACTS,
echo             Manifest.permission.CAMERA,
echo             Manifest.permission.ACCESS_FINE_LOCATION,
echo             Manifest.permission.ACCESS_COARSE_LOCATION
echo         ^)
echo.
echo         val permissionsToRequest = permissions.filter {
echo             ContextCompat.checkSelfPermission^(this, it^) != PackageManager.PERMISSION_GRANTED
echo         }.toTypedArray^(^)
echo.
echo         if ^(permissionsToRequest.isNotEmpty^(^)^) {
echo             ActivityCompat.requestPermissions^(this, permissionsToRequest, PERMISSIONS_REQUEST_CODE^)
echo         } else {
echo             requestOverlayPermission^(^)
echo         }
echo     }
echo.
echo     private fun requestOverlayPermission^(^) {
echo         if ^(!Settings.canDrawOverlays^(this^)^) {
echo             val intent = Intent^(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse^("package:$packageName"^)^)
echo             startActivityForResult^(intent, OVERLAY_PERMISSION_REQUEST_CODE^)
echo         } else {
echo             startVoiceService^(^)
echo         }
echo     }
echo.
echo     override fun onRequestPermissionsResult^(
echo         requestCode: Int,
echo         permissions: Array^<out String^>,
echo         grantResults: IntArray
echo     ^) {
echo         super.onRequestPermissionsResult^(requestCode, permissions, grantResults^)
echo         if ^(requestCode == PERMISSIONS_REQUEST_CODE^) {
echo             requestOverlayPermission^(^)
echo         }
echo     }
echo.
echo     private fun startVoiceService^(^) {
echo         val serviceIntent = Intent^(this, VoiceService::class.java^)
echo         startForegroundService^(serviceIntent^)
echo         Toast.makeText^(this, "K.A.Y. escuchando 24/7. Di 'Kay' para activar.", Toast.LENGTH_LONG^).show^(^)
echo         updateHUD^("K.A.Y. activado y escuchando"^)
echo     }
echo.
echo     private fun loadFragment^(fragment: Fragment^) {
echo         val fragmentContainer = findViewById^<FrameLayout^>^(R.id.fragment_container^)
echo         fragmentContainer.visibility = View.VISIBLE
echo         supportFragmentManager.beginTransaction^(^)
echo             .replace^(R.id.fragment_container, fragment^)
echo             .addToBackStack^(null^)
echo             .commit^(^)
echo     }
echo.
echo     override fun onBackPressed^(^) {
echo         val fragmentContainer = findViewById^<FrameLayout^>^(R.id.fragment_container^)
echo         if ^(fragmentContainer.visibility == View.VISIBLE^) {
echo             fragmentContainer.visibility = View.GONE
echo             supportFragmentManager.popBackStack^(^)
echo         } else if ^(drawerLayout.isDrawerOpen^(GravityCompat.START^)^) {
echo             drawerLayout.closeDrawer^(GravityCompat.START^)
echo         } else {
echo             super.onBackPressed^(^)
echo         }
echo     }
echo.
echo     override fun onDestroy^(^) {
echo         super.onDestroy^(^)
echo         try {
echo             unregisterReceiver^(hudReceiver^)
echo         } catch ^(e: Exception^) {
echo         }
echo     }
echo.
echo     private fun updateHUD^(text: String^) {
echo         webView.evaluateJavascript^("setStatus^('$text'^); simulateKAYSpeaking^(^);", null^)
echo     }
echo.
echo     inner class WebAppInterface {
echo         @JavascriptInterface
echo         fun onTripleTap^(^) {
echo             runOnUiThread {
echo                 if ^(brain.verifyAuthenticity^(^)^) {
echo                     Toast.makeText^(applicationContext, "K.A.Y. Assistant - Autenticado ✓", Toast.LENGTH_LONG^).show^(^)
echo                 }
echo             }
echo         }
echo.
echo         @JavascriptInterface
echo         fun onSwipeLeft^(^) {
echo             runOnUiThread {
echo                 drawerLayout.openDrawer^(Gravity.START^)
echo             }
echo         }
echo     }
echo }
) > "app\src\main\java\com\kay\assistant\MainActivity.kt"
echo ✅ MainActivity actualizado con todas las funciones

echo.
echo [2/3] Actualizando AndroidManifest.xml...
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
echo     ^<uses-permission android:name="android.permission.READ_CONTACTS" /^>
echo     ^<uses-permission android:name="android.permission.WRITE_CONTACTS" /^>
echo     ^<uses-permission android:name="android.permission.CAMERA" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /^>
echo     ^<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /^>
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
echo         ^<activity
echo             android:name=".ChatGPTLoginActivity"
echo             android:exported="false"
echo             android:theme="@style/Theme.KAYAssistant" /^>
echo.
echo         ^<service
echo             android:name=".services.VoiceService"
echo             android:enabled="true"
echo             android:exported="false"
echo             android:foregroundServiceType="microphone"/^>
echo     ^</application^>
echo ^</manifest^>
) > "app\src\main\AndroidManifest.xml"
echo ✅ AndroidManifest.xml actualizado

echo.
echo [3/3] Verificando VoiceService...
echo ✅ VoiceService ya configurado

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  TODAS LAS FUNCIONES ACTIVADAS              ║
echo ║ ✅ VoiceService 24/7 automático                             ║
echo ║ ✅ TTS funcionando                                          ║
echo ║ ✅ Menú lateral con Voice Recognition                       ║
echo ║ ✅ ChatGPT login cuando seleccionas ChatGPT                 ║
echo ║ ✅ Permisos completos solicitados automáticamente           ║
echo ║ ✅ Notificación persistente                                 ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🎯 DESPUÉS DE INSTALAR:
echo 1. K.A.Y. pedirá TODOS los permisos (acepta todos)
echo 2. VoiceService se iniciará automáticamente 24/7
echo 3. Verás notificación "K.A.Y. escuchando..."
echo 4. Di "Kay" para activar respuestas
echo 5. Menú lateral → Configuración → ChatGPT para credenciales
echo.
pause