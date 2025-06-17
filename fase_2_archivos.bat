@echo off
chcp 65001 > nul
color 0B
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    K.A.Y. FASE 2 - ARCHIVOS                 ║
echo ║                  MainActivity + HUD 3D                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/4] Actualizando MainActivity.kt...
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
echo import android.view.MenuItem
echo import android.view.Gravity
echo import androidx.fragment.app.Fragment
echo import androidx.core.view.GravityCompat
echo import android.view.View
echo import android.widget.FrameLayout
echo.
echo class MainActivity : AppCompatActivity^(^) {
echo     private lateinit var webView: WebView
echo     private lateinit var drawerLayout: DrawerLayout
echo     private lateinit var navigationView: NavigationView
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
echo.
echo     override fun onCreate^(savedInstanceState: Bundle?^) {
echo         super.onCreate^(savedInstanceState^)
echo         setContentView^(R.layout.activity_main^)
echo.
echo         setupWebView^(^)
echo         setupNavigationDrawer^(^)
echo         checkAndRequestPermissions^(^)
echo.        
echo         val filter = IntentFilter^("com.kay.assistant.UPDATE_HUD"^)
echo         ContextCompat.registerReceiver^(
echo             this,
echo             hudReceiver,
echo             filter,
echo             ContextCompat.RECEIVER_NOT_EXPORTED
echo         ^)
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
echo.        
echo         webView.addJavascriptInterface^(WebAppInterface^(^), "Android"^)
echo.        
echo         webView.loadUrl^("file:///android_asset/kay_hud.html"^)
echo     }
echo.
echo     private fun setupNavigationDrawer^(^) {
echo         drawerLayout = findViewById^(R.id.drawer_layout^)
echo         navigationView = findViewById^(R.id.nav_view^)
echo.
echo         navigationView.setNavigationItemSelectedListener { menuItem -^>
echo             when ^(menuItem.itemId^) {
echo                 R.id.nav_settings -^> {
echo                     loadFragment^(SettingsFragment^(^)^)
echo                     drawerLayout.closeDrawer^(GravityCompat.START^)
echo                     true
echo                 }
echo                 else -^> false
echo             }
echo         }
echo     }
echo.
echo     private fun loadFragment^(fragment: Fragment^) {
echo         val fragmentContainer = findViewById^<FrameLayout^>^(R.id.fragment_container^)
echo         fragmentContainer.visibility = View.VISIBLE
echo.        
echo         supportFragmentManager.beginTransaction^(^)
echo             .replace^(R.id.fragment_container, fragment^)
echo             .addToBackStack^(null^)
echo             .commit^(^)
echo     }
echo.
echo     private fun checkAndRequestPermissions^(^) {
echo         val permissions = arrayOf^(
echo             Manifest.permission.RECORD_AUDIO,
echo             Manifest.permission.WRITE_EXTERNAL_STORAGE,
echo             Manifest.permission.READ_EXTERNAL_STORAGE,
echo             Manifest.permission.SYSTEM_ALERT_WINDOW,
echo             Manifest.permission.WRITE_SETTINGS,
echo             Manifest.permission.ACCESS_NOTIFICATION_POLICY,
echo             Manifest.permission.WAKE_LOCK,
echo             Manifest.permission.POST_NOTIFICATIONS
echo         ^)
echo.
echo         val permissionsToRequest = permissions.filter {
echo             ContextCompat.checkSelfPermission^(this, it^) != PackageManager.PERMISSION_GRANTED
echo         }.toTypedArray^(^)
echo.
echo         if ^(permissionsToRequest.isNotEmpty^(^)^) {
echo             ActivityCompat.requestPermissions^(this, permissionsToRequest, PERMISSIONS_REQUEST_CODE^)
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
echo             if ^(grantResults.isNotEmpty^(^) ^&^& grantResults.any { it == PackageManager.PERMISSION_GRANTED }^) {
echo                 startVoiceService^(^)
echo             } else {
echo                 Toast.makeText^(this, "Algunos permisos son necesarios para el funcionamiento completo", Toast.LENGTH_LONG^).show^(^)
echo             }
echo         }
echo     }
echo.
echo     private fun startVoiceService^(^) {
echo         val serviceIntent = Intent^(this, VoiceService::class.java^)
echo         startForegroundService^(serviceIntent^)
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
echo         webView.evaluateJavascript^(
echo             "setStatus^('$text'^); simulateKAYSpeaking^(^);",
echo             null
echo         ^)
echo     }
echo.
echo     inner class WebAppInterface {
echo         @JavascriptInterface
echo         fun onSingleTap^(^) {
echo             runOnUiThread {
echo                 webView.evaluateJavascript^("simulateUserSpeaking^(^);", null^)
echo             }
echo         }
echo.
echo         @JavascriptInterface
echo         fun onDoubleTap^(^) {
echo             runOnUiThread {
echo                 webView.evaluateJavascript^("simulateKAYSpeaking^(^);", null^)
echo             }
echo         }
echo.
echo         @JavascriptInterface
echo         fun onTripleTap^(^) {
echo             runOnUiThread {
echo                 val brain = KAYBrain^(applicationContext^)
echo                 if ^(brain.verifyAuthenticity^(^)^) {
echo                     Toast.makeText^(
echo                         applicationContext,
echo                         "K.A.Y. Assistant - Autenticado ✓",
echo                         Toast.LENGTH_LONG
echo                     ^).show^(^)
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
echo ✅ MainActivity.kt actualizado
echo.

echo [2/4] Actualizando activity_main.xml...
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<androidx.drawerlayout.widget.DrawerLayout xmlns:android="http://schemas.android.com/apk/res/android"
echo     xmlns:app="http://schemas.android.com/apk/res-auto"
echo     android:id="@+id/drawer_layout"
echo     android:layout_width="match_parent"
echo     android:layout_height="match_parent"
echo     android:fitsSystemWindows="true"^>
echo.
echo     ^<FrameLayout
echo         android:layout_width="match_parent"
echo         android:layout_height="match_parent"^>
echo.
echo         ^<WebView
echo             android:id="@+id/webView"
echo             android:layout_width="match_parent"
echo             android:layout_height="match_parent" /^>
echo.
echo         ^<FrameLayout
echo             android:id="@+id/fragment_container"
echo             android:layout_width="match_parent"
echo             android:layout_height="match_parent"
echo             android:visibility="gone"
echo             android:background="#CC000000" /^>
echo.
echo     ^</FrameLayout^>
echo.
echo     ^<com.google.android.material.navigation.NavigationView
echo         android:id="@+id/nav_view"
echo         android:layout_width="wrap_content"
echo         android:layout_height="match_parent"
echo         android:layout_gravity="start"
echo         android:fitsSystemWindows="true"
echo         app:headerLayout="@layout/nav_header"
echo         app:menu="@menu/drawer_menu" /^>
echo.
echo ^</androidx.drawerlayout.widget.DrawerLayout^>
) > "app\src\main\res\layout\activity_main.xml"
echo ✅ activity_main.xml actualizado
echo.

echo [3/4] Agregando respuesta al nombre en KAYBrain.kt...
echo ✅ (Agregar manualmente las líneas del nombre "Kay")
echo.

echo [4/4] Preparando kay_hud.html...
echo ✅ (Se creará en la siguiente fase por su tamaño)
echo.

echo ╔══════════════════════════════════════════════════════════════╗
echo ║                     FASE 2 COMPLETADA                       ║
echo ║ ✅ MainActivity.kt actualizado (con WebInterface)           ║
echo ║ ✅ activity_main.xml corregido                               ║
echo ║ ✅ Archivos principales listos                               ║
echo ║                                                              ║
echo ║ 🔧 SIGUIENTE: Ejecutar fase_3_hud.bat                       ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause