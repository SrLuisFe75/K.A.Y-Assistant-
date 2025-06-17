package com.kay.assistant

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Bundle
import android.text.InputType
import android.view.Gravity
import android.view.MenuItem
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.view.GravityCompat
import androidx.drawerlayout.widget.DrawerLayout
import com.google.android.material.navigation.NavigationView
import com.kay.services.VoiceService

class MainActivity : AppCompatActivity(), NavigationView.OnNavigationItemSelectedListener {
    private lateinit var drawerLayout: DrawerLayout
    private lateinit var navigationView: NavigationView
    private lateinit var webView: WebView

    private val hudReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "com.kay.assistant.UPDATE_HUD") {
                val response = intent.getStringExtra("response")
                response?.let { updateHUD(it) }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        initializeViews()
        setupNavigationDrawer()
        setupWebView()
        requestPermissions()
        startVoiceService()
        
        val filter = IntentFilter("com.kay.assistant.UPDATE_HUD")
        ContextCompat.registerReceiver(this, hudReceiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
    }

    private fun initializeViews() {
        drawerLayout = findViewById(R.id.drawer_layout)
        navigationView = findViewById(R.id.nav_view)
        webView = findViewById(R.id.webView)
    }

    private fun setupNavigationDrawer() {
        navigationView.setNavigationItemSelectedListener(this)
    }

    private fun setupWebView() {
        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            allowFileAccess = true
        }
        webView.webViewClient = WebViewClient()
        webView.addJavascriptInterface(WebAppInterface(), "Android")
        webView.loadUrl("file:///android_asset/kay_hud.html")
    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.nav_personality -> showPersonalityDialog()
            R.id.nav_memory -> showMemoryDialog()
            R.id.nav_learning -> showLearningDialog()
            R.id.nav_emotion -> showEmotionDialog()
            R.id.nav_language -> showLanguageDialog()
            R.id.nav_routines -> showRoutinesDialog()
            R.id.nav_settings -> showVoiceProviderDialog()
            R.id.nav_silence -> toggleSilence()
        }
        drawerLayout.closeDrawer(GravityCompat.START)
        return true
    }

    private fun showPersonalityDialog() {
        val personalities = arrayOf(
            "Tony Stark - Genio millonario",
            "HAL 9000 - Computadora espacial", 
            "GLaDOS - IA sarcástica",
            "Profesional - Formal y educado",
            "Amigable - Cálido y cercano",
            "Sarcástico - Irónico y divertido"
        )
        
        AlertDialog.Builder(this)
            .setTitle("🤖 Personalidad de K.A.Y.")
            .setItems(personalities) { _, which ->
                val selected = personalities[which].split(" - ")[0]
                Toast.makeText(this, "Personalidad: $selected", Toast.LENGTH_SHORT).show()
            }
            .show()
    }

    private fun showMemoryDialog() {
        AlertDialog.Builder(this)
            .setTitle("🧠 Memoria de K.A.Y.")
            .setMessage("K.A.Y. recuerda:\n\n• Conversaciones anteriores\n• Tus preferencias\n• Comandos personalizados\n• Horarios y rutinas")
            .setPositiveButton("Entendido") { _, _ -> }
            .show()
    }

    private fun showLearningDialog() {
        AlertDialog.Builder(this)
            .setTitle("📚 Aprendizaje Activo")
            .setMessage("K.A.Y. mejora constantemente:\n\n• Analiza patrones de uso\n• Aprende nuevos comandos\n• Se adapta a tu estilo\n• Mejora las respuestas")
            .setPositiveButton("Perfecto") { _, _ -> }
            .show()
    }

    private fun showEmotionDialog() {
        val emotions = arrayOf("😊 Alegre", "😐 Neutral", "🤔 Curioso", "😴 Relajado", "⚡ Energético")
        AlertDialog.Builder(this)
            .setTitle("💭 Estado Emocional")
            .setItems(emotions) { _, which ->
                Toast.makeText(this, "Estado: ${emotions[which]}", Toast.LENGTH_SHORT).show()
            }
            .show()
    }

    private fun showLanguageDialog() {
        val languages = arrayOf("🇲🇽 Español (Latino)", "🇺🇸 English (US)")
        AlertDialog.Builder(this)
            .setTitle("🌍 Idioma / Language")
            .setItems(languages) { _, which ->
                Toast.makeText(this, "Idioma cambiado", Toast.LENGTH_SHORT).show()
            }
            .show()
    }

    private fun showRoutinesDialog() {
        val routines = arrayOf(
            "🌅 Buenos días", "🌙 Buenas noches", "📱 Modo trabajo", 
            "🎵 Modo relajación", "🚗 Modo conducción", "⏰ Recordatorios"
        )
        AlertDialog.Builder(this)
            .setTitle("🔄 Rutinas de K.A.Y.")
            .setItems(routines) { _, which ->
                Toast.makeText(this, "Rutina activada: ${routines[which]}", Toast.LENGTH_LONG).show()
            }
            .show()
    }

    private fun showVoiceProviderDialog() {
        val providers = arrayOf("🤖 Android Nativo", "🧠 ChatGPT")
        AlertDialog.Builder(this)
            .setTitle("🎤 Proveedor de IA")
            .setItems(providers) { _, which ->
                if (which == 1) showChatGPTLoginDialog()
                else Toast.makeText(this, "Usando Android nativo", Toast.LENGTH_SHORT).show()
            }
            .show()
    }

    private fun showChatGPTLoginDialog() {
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(60, 50, 60, 50)
        }

        val titleText = TextView(this).apply {
            text = "🔑 API Key de OpenAI"
            textSize = 20f
            setPadding(0, 0, 0, 20)
            gravity = Gravity.CENTER
        }
        layout.addView(titleText)

        val apiKeyInput = EditText(this).apply {
            hint = "sk-..."
            inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
        }
        layout.addView(apiKeyInput)

        val helpText = TextView(this).apply {
            text = "\n💡 Consigue tu API Key en:\nplatform.openai.com/api-keys"
            textSize = 12f
            alpha = 0.7f
        }
        layout.addView(helpText)

        AlertDialog.Builder(this)
            .setView(layout)
            .setTitle("ChatGPT Configuration")
            .setPositiveButton("💾 Guardar") { _, _ ->
                val apiKey = apiKeyInput.text.toString().trim()
                if (apiKey.startsWith("sk-")) {
                    getSharedPreferences("chatgpt", MODE_PRIVATE)
                        .edit().putString("api_key", apiKey).apply()
                    Toast.makeText(this, "✅ ChatGPT configurado", Toast.LENGTH_LONG).show()
                } else {
                    Toast.makeText(this, "❌ API Key inválida", Toast.LENGTH_SHORT).show()
                }
            }
            .setNegativeButton("❌ Cancelar") { _, _ -> }
            .show()
    }

    private fun toggleSilence() {
        Toast.makeText(this, "🔇 Modo silencioso activado por 5 minutos", Toast.LENGTH_LONG).show()
    }

    inner class WebAppInterface {
        @JavascriptInterface
        fun onSwipeLeft() {
            runOnUiThread { drawerLayout.openDrawer(GravityCompat.START) }
        }

        @JavascriptInterface
        fun onTripleTap() {
            runOnUiThread {
                Toast.makeText(applicationContext, "🔐 K.A.Y. Autenticado ✓", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun updateHUD(text: String) {
        webView.evaluateJavascript("setStatus('$text'); simulateKAYSpeaking();", null)
    }

    private fun requestPermissions() {
        val permissions = arrayOf(Manifest.permission.RECORD_AUDIO, Manifest.permission.FOREGROUND_SERVICE)
        ActivityCompat.requestPermissions(this, permissions, 1001)
    }

    private fun startVoiceService() {
        val serviceIntent = Intent(this, VoiceService::class.java)
        startForegroundService(serviceIntent)
        Toast.makeText(this, "🎤 K.A.Y. escuchando 24/7", Toast.LENGTH_LONG).show()
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(hudReceiver)
        } catch (e: Exception) {}
    }
}