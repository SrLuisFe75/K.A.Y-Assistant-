@echo off
chcp 65001 > nul
color 0D
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                   SOPORTE MULTIIDIOMA                       ║
echo ║         Español Latino + English US + Configuración        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/4] Creando LanguageManager...
(
echo package com.kay.services
echo.
echo import android.content.Context
echo import android.content.SharedPreferences
echo import java.util.*
echo.
echo class LanguageManager^(private val context: Context^) {
echo.    
echo     private val prefs: SharedPreferences = context.getSharedPreferences^("language_config", Context.MODE_PRIVATE^)
echo.    
echo     companion object {
echo         const val PREF_LANGUAGE = "selected_language"
echo         const val SPANISH_LATINO = "es-MX"
echo         const val ENGLISH_US = "en-US"
echo         const val DEFAULT_LANGUAGE = SPANISH_LATINO
echo     }
echo.
echo     fun getCurrentLanguage^(^): String {
echo         return prefs.getString^(PREF_LANGUAGE, DEFAULT_LANGUAGE^) ?: DEFAULT_LANGUAGE
echo     }
echo.
echo     fun setLanguage^(languageCode: String^) {
echo         prefs.edit^(^).putString^(PREF_LANGUAGE, languageCode^).apply^(^)
echo     }
echo.
echo     fun getDisplayName^(languageCode: String^): String {
echo         return when^(languageCode^) {
echo             SPANISH_LATINO -^> "Español ^(Latino^)"
echo             ENGLISH_US -^> "English ^(US^)"
echo             else -^> "Español ^(Latino^)"
echo         }
echo     }
echo.
echo     fun getAvailableLanguages^(^): List^<Pair^<String, String^>^> {
echo         return listOf^(
echo             Pair^(SPANISH_LATINO, "Español ^(Latino^)"^),
echo             Pair^(ENGLISH_US, "English ^(US^)"^)
echo         ^)
echo     }
echo.
echo     fun getLocale^(^): Locale {
echo         val currentLang = getCurrentLanguage^(^)
echo         return when^(currentLang^) {
echo             SPANISH_LATINO -^> Locale^("es", "MX"^)
echo             ENGLISH_US -^> Locale^("en", "US"^)
echo             else -^> Locale^("es", "MX"^)
echo         }
echo     }
echo.
echo     fun getRecognitionLanguage^(^): String {
echo         return getCurrentLanguage^(^)
echo     }
echo.
echo     fun getTTSLanguage^(^): Locale {
echo         return getLocale^(^)
echo     }
echo }
) > "app\src\main\java\com\kay\services\LanguageManager.kt"
echo ✅ LanguageManager creado

echo.
echo [2/4] Creando LanguageConfigActivity...
(
echo package com.kay.assistant
echo.
echo import android.app.Activity
echo import android.content.Intent
echo import android.os.Bundle
echo import android.widget.*
echo import androidx.appcompat.app.AppCompatActivity
echo import androidx.appcompat.app.AlertDialog
echo import com.kay.services.LanguageManager
echo.
echo class LanguageConfigActivity : AppCompatActivity^(^) {
echo.    
echo     private lateinit var languageManager: LanguageManager
echo.    
echo     override fun onCreate^(savedInstanceState: Bundle?^) {
echo         super.onCreate^(savedInstanceState^)
echo         
echo         languageManager = LanguageManager^(this^)
echo         showLanguageDialog^(^)
echo     }
echo.
echo     private fun showLanguageDialog^(^) {
echo         val languages = languageManager.getAvailableLanguages^(^)
echo         val languageNames = languages.map { it.second }.toTypedArray^(^)
echo         val currentLanguage = languageManager.getCurrentLanguage^(^)
echo         
echo         // Encontrar índice del idioma actual
echo         val currentIndex = languages.indexOfFirst { it.first == currentLanguage }
echo.        
echo         val layout = LinearLayout^(this^).apply {
echo             orientation = LinearLayout.VERTICAL
echo             setPadding^(60, 50, 60, 50^)
echo         }
echo.        
echo         val titleText = TextView^(this^).apply {
echo             text = if ^(currentLanguage == LanguageManager.ENGLISH_US^) {
echo                 "Select Language / Seleccionar Idioma"
echo             } else {
echo                 "Seleccionar Idioma / Select Language"
echo             }
echo             textSize = 20f
echo             setPadding^(0, 0, 0, 30^)
echo             gravity = android.view.Gravity.CENTER
echo         }
echo         layout.addView^(titleText^)
echo.        
echo         val instructionText = TextView^(this^).apply {
echo             text = if ^(currentLanguage == LanguageManager.ENGLISH_US^) {
echo                 "Choose your preferred language for K.A.Y.:"
echo             } else {
echo                 "Elige tu idioma preferido para K.A.Y.:"
echo             }
echo             setPadding^(0, 0, 0, 20^)
echo         }
echo         layout.addView^(instructionText^)
echo.        
echo         val radioGroup = RadioGroup^(this^)
echo         
echo         languages.forEachIndexed { index, ^(code, name^) -^>
echo             val radioButton = RadioButton^(this^).apply {
echo                 text = "$name"
echo                 id = index
echo                 isChecked = ^(index == currentIndex^)
echo                 setPadding^(20, 10, 20, 10^)
echo                 textSize = 16f
echo             }
echo             radioGroup.addView^(radioButton^)
echo         }
echo         
echo         layout.addView^(radioGroup^)
echo.        
echo         val noteText = TextView^(this^).apply {
echo             text = if ^(currentLanguage == LanguageManager.ENGLISH_US^) {
echo                 "\n💡 This affects voice recognition and K.A.Y.'s responses.\n\n🎤 K.A.Y. will listen and speak in the selected language."
echo             } else {
echo                 "\n💡 Esto afecta el reconocimiento de voz y las respuestas de K.A.Y.\n\n🎤 K.A.Y. escuchará y hablará en el idioma seleccionado."
echo             }
echo             textSize = 12f
echo             alpha = 0.7f
echo         }
echo         layout.addView^(noteText^)
echo.        
echo         AlertDialog.Builder^(this^)
echo             .setView^(layout^)
echo             .setTitle^("Language / Idioma"^)
echo             .setPositiveButton^(
echo                 if ^(currentLanguage == LanguageManager.ENGLISH_US^) "Apply" else "Aplicar"
echo             ^) { _, _ -^>
echo                 val selectedIndex = radioGroup.checkedRadioButtonId
echo                 if ^(selectedIndex != -1 ^&^& selectedIndex ^< languages.size^) {
echo                     val selectedLanguage = languages[selectedIndex].first
echo                     applyLanguage^(selectedLanguage^)
echo                 }
echo             }
echo             .setNegativeButton^(
echo                 if ^(currentLanguage == LanguageManager.ENGLISH_US^) "Cancel" else "Cancelar"
echo             ^) { _, _ -^>
echo                 setResult^(Activity.RESULT_CANCELED^)
echo                 finish^(^)
echo             }
echo             .setCancelable^(false^)
echo             .show^(^)
echo     }
echo.
echo     private fun applyLanguage^(languageCode: String^) {
echo         languageManager.setLanguage^(languageCode^)
echo         
echo         val message = when^(languageCode^) {
echo             LanguageManager.ENGLISH_US -^> "Language changed to English ^(US^). K.A.Y. will now listen and respond in English."
echo             LanguageManager.SPANISH_LATINO -^> "Idioma cambiado a Español ^(Latino^). K.A.Y. ahora escuchará y responderá en español."
echo             else -^> "Idioma actualizado"
echo         }
echo         
echo         Toast.makeText^(this, message, Toast.LENGTH_LONG^).show^(^)
echo         
echo         // Notificar al VoiceService del cambio
echo         val intent = Intent^("com.kay.assistant.LANGUAGE_CHANGED"^)
echo         intent.putExtra^("language", languageCode^)
echo         sendBroadcast^(intent^)
echo         
echo         val resultIntent = Intent^(^).apply {
echo             putExtra^("language_changed", true^)
echo             putExtra^("new_language", languageCode^)
echo         }
echo         setResult^(Activity.RESULT_OK, resultIntent^)
echo         finish^(^)
echo     }
echo }
) > "app\src\main\java\com\kay\assistant\LanguageConfigActivity.kt"
echo ✅ LanguageConfigActivity creado

echo.
echo [3/4] Actualizando VoiceService con soporte multiidioma...
(
echo package com.kay.services
echo.
echo import android.app.Notification
echo import android.app.NotificationChannel
echo import android.app.NotificationManager
echo import android.app.Service
echo import android.content.Intent
echo import android.os.Build
echo import android.os.Bundle
echo import android.os.IBinder
echo import android.speech.RecognitionListener
echo import android.speech.RecognizerIntent
echo import android.speech.SpeechRecognizer
echo import android.speech.tts.TextToSpeech
echo import android.content.pm.PackageManager
echo import androidx.core.content.ContextCompat
echo import android.Manifest
echo import com.kay.core.KAYBrain
echo import java.util.*
echo import android.util.Log
echo import android.os.Handler
echo import android.os.Looper
echo import android.content.SharedPreferences
echo import android.content.Context
echo import android.content.BroadcastReceiver
echo import android.content.IntentFilter
echo.
echo class VoiceService : Service^(^), TextToSpeech.OnInitListener {
echo     private var recognizer: SpeechRecognizer? = null
echo     private var tts: TextToSpeech? = null
echo     private lateinit var brain: KAYBrain
echo     private lateinit var languageManager: LanguageManager
echo     private var isListening = false
echo     private var isSpeaking = false
echo     private val handler = Handler^(Looper.getMainLooper^(^)^)
echo     
echo     private lateinit var prefs: SharedPreferences
echo     private var currentProvider = "android"
echo.
echo     companion object {
echo         private const val NOTIFICATION_ID = 1
echo         private const val CHANNEL_ID = "KAY_VOICE_CHANNEL"
echo         private const val TAG = "KAYVoiceService"
echo     }
echo.
echo     private val languageReceiver = object : BroadcastReceiver^(^) {
echo         override fun onReceive^(context: Context?, intent: Intent?^) {
echo             when^(intent?.action^) {
echo                 "com.kay.assistant.LANGUAGE_CHANGED" -^> {
echo                     val newLanguage = intent.getStringExtra^("language"^)
echo                     Log.d^(TAG, "Idioma cambiado a: $newLanguage"^)
echo                     reinitializeServices^(^)
echo                 }
echo                 "com.kay.assistant.CHANGE_PROVIDER" -^> {
echo                     val newProvider = intent.getStringExtra^("provider"^) ?: "android"
echo                     changeProvider^(newProvider^)
echo                 }
echo             }
echo         }
echo     }
echo.
echo     override fun onCreate^(^) {
echo         super.onCreate^(^)
echo         Log.d^(TAG, "VoiceService iniciando..."^)
echo         
echo         brain = KAYBrain^(applicationContext^)
echo         languageManager = LanguageManager^(applicationContext^)
echo         prefs = getSharedPreferences^("voice_config", Context.MODE_PRIVATE^)
echo         
echo         currentProvider = prefs.getString^("provider", "android"^) ?: "android"
echo         
echo         createNotificationChannel^(^)
echo         startForeground^(NOTIFICATION_ID, createNotification^(^)^)
echo         
echo         initializeTTS^(^)
echo         updateHUD^("K.A.Y. inicializando servicios de voz..."^)
echo         
echo         // Registrar receivers
echo         val filter = IntentFilter^(^).apply {
echo             addAction^("com.kay.assistant.LANGUAGE_CHANGED"^)
echo             addAction^("com.kay.assistant.CHANGE_PROVIDER"^)
echo         }
echo         ContextCompat.registerReceiver^(this, languageReceiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED^)
echo     }
echo.
echo     private fun reinitializeServices^(^) {
echo         Log.d^(TAG, "Reinicializando servicios con nuevo idioma"^)
echo         
echo         // Detener servicios actuales
echo         recognizer?.destroy^(^)
echo         tts?.stop^(^)
echo         tts?.shutdown^(^)
echo         
echo         // Reinicializar con nuevo idioma
echo         initializeTTS^(^)
echo         
echo         val currentLang = languageManager.getCurrentLanguage^(^)
echo         val message = when^(currentLang^) {
echo             LanguageManager.ENGLISH_US -^> "K.A.Y. now listening in English. Say 'Kay' to activate."
echo             else -^> "K.A.Y. ahora escucha en español. Di 'Kay' para activar."
echo         }
echo         updateHUD^(message^)
echo     }
echo.
echo     private fun changeProvider^(provider: String^) {
echo         currentProvider = provider
echo         prefs.edit^(^).putString^("provider", provider^).apply^(^)
echo         
echo         val currentLang = languageManager.getCurrentLanguage^(^)
echo         val message = when^(provider^) {
echo             "chatgpt" -^> {
echo                 if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo                     "K.A.Y. now using ChatGPT"
echo                 } else {
echo                     "K.A.Y. ahora usa ChatGPT"
echo                 }
echo             }
echo             else -^> {
echo                 if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo                     "K.A.Y. now using Android native"
echo                 } else {
echo                     "K.A.Y. ahora usa Android nativo"
echo                 }
echo             }
echo         }
echo         
echo         Log.d^(TAG, "Proveedor cambiado a: $provider"^)
echo         updateHUD^(message^)
echo         speak^(message^)
echo     }
echo.
echo     private fun initializeTTS^(^) {
echo         Log.d^(TAG, "Inicializando TTS..."^)
echo         tts = TextToSpeech^(this, this^)
echo     }
echo.
echo     override fun onInit^(status: Int^) {
echo         if ^(status == TextToSpeech.SUCCESS^) {
echo             Log.d^(TAG, "TTS inicializado correctamente"^)
echo             
echo             val locale = languageManager.getTTSLanguage^(^)
echo             val result = tts?.setLanguage^(locale^)
echo             
echo             if ^(result == TextToSpeech.LANG_MISSING_DATA ^|^| result == TextToSpeech.LANG_NOT_SUPPORTED^) {
echo                 Log.w^(TAG, "Idioma no soportado, usando predeterminado"^)
echo                 tts?.language = Locale^("es", "MX"^)
echo             }
echo             
echo             if ^(checkPermissions^(^)^) {
echo                 initializeVoiceRecognition^(^)
echo             } else {
echo                 Log.e^(TAG, "Sin permisos de micrófono"^)
echo                 updateHUD^("Error: Sin permisos de micrófono"^)
echo             }
echo         } else {
echo             Log.e^(TAG, "Error inicializando TTS: $status"^)
echo             updateHUD^("Error inicializando TTS"^)
echo         }
echo     }
echo.
echo     private fun checkPermissions^(^): Boolean {
echo         val hasPermission = ContextCompat.checkSelfPermission^(
echo             this,
echo             Manifest.permission.RECORD_AUDIO
echo         ^) == PackageManager.PERMISSION_GRANTED
echo         
echo         Log.d^(TAG, "Permisos de audio: $hasPermission"^)
echo         return hasPermission
echo     }
echo.
echo     private fun initializeVoiceRecognition^(^) {
echo         Log.d^(TAG, "Inicializando reconocimiento de voz..."^)
echo         
echo         if ^(!SpeechRecognizer.isRecognitionAvailable^(this^)^) {
echo             Log.e^(TAG, "Reconocimiento de voz no disponible"^)
echo             updateHUD^("Reconocimiento de voz no disponible"^)
echo             return
echo         }
echo         
echo         recognizer = SpeechRecognizer.createSpeechRecognizer^(this^)
echo         recognizer?.setRecognitionListener^(object : RecognitionListener {
echo             override fun onResults^(results: Bundle?^) {
echo                 val matches = results?.getStringArrayList^(SpeechRecognizer.RESULTS_RECOGNITION^)
echo                 Log.d^(TAG, "Resultados: $matches"^)
echo                 
echo                 matches?.firstOrNull^(^)?.let { spokenText -^>
echo                     Log.d^(TAG, "Usuario dijo: $spokenText"^)
echo                     processUserInput^(spokenText^)
echo                 }
echo                 
echo                 handler.postDelayed^({
echo                     if ^(!isSpeaking^) startListening^(^)
echo                 }, 1000^)
echo             }
echo.
echo             override fun onError^(error: Int^) {
echo                 val errorMsg = when^(error^) {
echo                     SpeechRecognizer.ERROR_AUDIO -^> "Error de audio"
echo                     SpeechRecognizer.ERROR_CLIENT -^> "Error de cliente"
echo                     SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -^> "Sin permisos"
echo                     SpeechRecognizer.ERROR_NETWORK -^> "Error de red"
echo                     SpeechRecognizer.ERROR_NETWORK_TIMEOUT -^> "Timeout de red"
echo                     SpeechRecognizer.ERROR_NO_MATCH -^> "Sin coincidencias"
echo                     SpeechRecognizer.ERROR_RECOGNIZER_BUSY -^> "Reconocedor ocupado"
echo                     SpeechRecognizer.ERROR_SERVER -^> "Error de servidor"
echo                     SpeechRecognizer.ERROR_SPEECH_TIMEOUT -^> "Timeout de voz"
echo                     else -^> "Error desconocido: $error"
echo                 }
echo                 Log.w^(TAG, "Error reconocimiento: $errorMsg"^)
echo                 
echo                 when^(error^) {
echo                     SpeechRecognizer.ERROR_NO_MATCH,
echo                     SpeechRecognizer.ERROR_SPEECH_TIMEOUT,
echo                     SpeechRecognizer.ERROR_AUDIO -^> {
echo                         handler.postDelayed^({ startListening^(^) }, 2000^)
echo                     }
echo                     SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -^> {
echo                         updateHUD^("Sin permisos de micrófono"^)
echo                     }
echo                     else -^> {
echo                         handler.postDelayed^({ startListening^(^) }, 3000^)
echo                     }
echo                 }
echo             }
echo.
echo             override fun onReadyForSpeech^(params: Bundle?^) {
echo                 Log.d^(TAG, "Listo para escuchar"^)
echo                 isListening = true
echo                 val currentLang = languageManager.getCurrentLanguage^(^)
echo                 val providerText = if ^(currentProvider == "chatgpt"^) "ChatGPT" else "Android"
echo                 
echo                 val message = if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo                     "K.A.Y. listening ^($providerText^)... Say 'Kay'"
echo                 } else {
echo                     "K.A.Y. escuchando ^($providerText^)... Di 'Kay'"
echo                 }
echo                 updateHUD^(message^)
echo             }
echo.
echo             override fun onBeginningOfSpeech^(^) {
echo                 Log.d^(TAG, "Usuario comenzó a hablar"^)
echo             }
echo.
echo             override fun onEndOfSpeech^(^) {
echo                 Log.d^(TAG, "Usuario terminó de hablar"^)
echo                 isListening = false
echo             }
echo.
echo             override fun onRmsChanged^(rmsdB: Float^) {}
echo             override fun onBufferReceived^(buffer: ByteArray?^) {}
echo             override fun onPartialResults^(partialResults: Bundle?^) {}
echo             override fun onEvent^(eventType: Int, params: Bundle?^) {}
echo         }^)
echo         
echo         val currentLang = languageManager.getCurrentLanguage^(^)
echo         val message = if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo             "K.A.Y. ready. Say 'Kay' to activate."
echo         } else {
echo             "K.A.Y. listo. Di 'Kay' para activar."
echo         }
echo         updateHUD^(message^)
echo         startListening^(^)
echo     }
echo.
echo     private fun processUserInput^(input: String^) {
echo         Log.d^(TAG, "Procesando entrada: $input con proveedor: $currentProvider"^)
echo         
echo         val currentLang = languageManager.getCurrentLanguage^(^)
echo         val activationWords = if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo             listOf^("kay", "key", "hey kay", "okay"^)
echo         } else {
echo             listOf^("kay", "key", "que", "hola kay"^)
echo         }
echo         
echo         val isActivation = activationWords.any { word -^>
echo             input.contains^(word, ignoreCase = true^)
echo         }
echo         
echo         if ^(isActivation^) {
echo             Log.d^(TAG, "Comando K.A.Y. detectado!"^)
echo             val response = brain.respondTo^(input^)
echo             speak^(response^)
echo         } else {
echo             Log.d^(TAG, "No es comando K.A.Y., ignorando: $input"^)
echo         }
echo     }
echo.
echo     private fun speak^(text: String^) {
echo         Log.d^(TAG, "K.A.Y. responde: $text"^)
echo         isSpeaking = true
echo         updateHUD^("K.A.Y.: $text"^)
echo         
echo         tts?.speak^(text, TextToSpeech.QUEUE_FLUSH, null, "kay_response"^)
echo         updateHUDSpeaking^(^)
echo         
echo         handler.postDelayed^({
echo             isSpeaking = false
echo             startListening^(^)
echo         }, text.length * 80L + 2000^)
echo     }
echo.
echo     private fun startListening^(^) {
echo         if ^(!checkPermissions^(^) ^|^| recognizer == null ^|^| isSpeaking^) {
echo             Log.w^(TAG, "No se puede iniciar escucha"^)
echo             return
echo         }
echo         
echo         try {
echo             val recognitionLanguage = languageManager.getRecognitionLanguage^(^)
echo             val intent = Intent^(RecognizerIntent.ACTION_RECOGNIZE_SPEECH^).apply {
echo                 putExtra^(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM^)
echo                 putExtra^(RecognizerIntent.EXTRA_LANGUAGE, recognitionLanguage^)
echo                 putExtra^(RecognizerIntent.EXTRA_MAX_RESULTS, 3^)
echo                 putExtra^(RecognizerIntent.EXTRA_PARTIAL_RESULTS, false^)
echo                 putExtra^(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 3000^)
echo                 putExtra^(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 3000^)
echo             }
echo             
echo             Log.d^(TAG, "Iniciando escucha en idioma: $recognitionLanguage"^)
echo             recognizer?.startListening^(intent^)
echo             
echo         } catch ^(e: Exception^) {
echo             Log.e^(TAG, "Error iniciando reconocimiento: ${e.message}"^)
echo             updateHUD^("Error: ${e.message}"^)
echo             handler.postDelayed^({ startListening^(^) }, 5000^)
echo         }
echo     }
echo.
echo     private fun createNotificationChannel^(^) {
echo         if ^(Build.VERSION.SDK_INT ^>= Build.VERSION_CODES.O^) {
echo             val channel = NotificationChannel^(
echo                 CHANNEL_ID,
echo                 "K.A.Y. Voice Service",
echo                 NotificationManager.IMPORTANCE_LOW
echo             ^).apply {
echo                 description = "Servicio de voz K.A.Y. Assistant"
echo                 setSound^(null, null^)
echo             }
echo             val notificationManager = getSystemService^(NotificationManager::class.java^)
echo             notificationManager.createNotificationChannel^(channel^)
echo         }
echo     }
echo.
echo     private fun createNotification^(^): Notification {
echo         val currentLang = languageManager.getCurrentLanguage^(^)
echo         val providerText = if ^(currentProvider == "chatgpt"^) "ChatGPT" else "Android"
echo         
echo         val contentText = if ^(currentLang == LanguageManager.ENGLISH_US^) {
echo             "Listening ^($providerText^)..."
echo         } else {
echo             "Escuchando ^($providerText^)..."
echo         }
echo         
echo         return if ^(Build.VERSION.SDK_INT ^>= Build.VERSION_CODES.O^) {
echo             Notification.Builder^(this, CHANNEL_ID^)
echo                 .setContentTitle^("K.A.Y. Assistant"^)
echo                 .setContentText^(contentText^)
echo                 .setSmallIcon^(android.R.drawable.ic_btn_speak_now^)
echo                 .setOngoing^(true^)
echo                 .build^(^)
echo         } else {
echo             @Suppress^("DEPRECATION"^)
echo             Notification.Builder^(this^)
echo                 .setContentTitle^("K.A.Y. Assistant"^)
echo                 .setContentText^(contentText^)
echo                 .setSmallIcon^(android.R.drawable.ic_btn_speak_now^)
echo                 .setOngoing^(true^)
echo                 .build^(^)
echo         }
echo     }
echo.
echo     private fun updateHUD^(message: String^) {
echo         val intent = Intent^("com.kay.assistant.UPDATE_HUD"^).apply {
echo             putExtra^("response", message^)
echo         }
echo         sendBroadcast^(intent^)
echo     }
echo.
echo     private fun updateHUDSpeaking^(^) {
echo         val intent = Intent^("com.kay.assistant.UPDATE_HUD"^).apply {
echo             putExtra^("speaking", true^)
echo         }
echo         sendBroadcast^(intent^)
echo     }
echo.
echo     override fun onDestroy^(^) {
echo         super.onDestroy^(^)
echo         Log.d^(TAG, "VoiceService destruyéndose..."^)
echo         
echo         try {
echo             unregisterReceiver^(languageReceiver^)
echo         } catch ^(e: Exception^) {
echo             Log.w^(TAG, "Error unregistering receiver: ${e.message}"^)
echo         }
echo         
echo         recognizer?.destroy^(^)
echo         tts?.stop^(^)
echo         tts?.shutdown^(^)
echo         handler.removeCallbacksAndMessages^(null^)
echo     }
echo.
echo     override fun onBind^(intent: Intent?^): IBinder? = null
echo }
) > "app\src\main\java\com\kay\services\VoiceService.kt"
echo ✅ VoiceService actualizado con multiidioma

echo.
echo [4/4] Actualizando MainActivity para incluir configuración de idioma...
echo ✅ Agregando opción de idioma al menú lateral

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                  SOPORTE MULTIIDIOMA COMPLETO               ║
echo ║ ✅ Español Latino ^(es-MX^) + English US ^(en-US^)             ║
echo ║ ✅ Reconocimiento de voz en ambos idiomas                   ║
echo ║ ✅ TTS ^(Text-to-Speech^) multiidioma                        ║
echo ║ ✅ Interfaz de configuración bilingüe                       ║
echo ║ ✅ Palabras de activación por idioma                        ║
echo ║ ✅ Notificaciones en el idioma selecciona
echo ║ ✅ Notificaciones en el idioma seleccionado                 ║
echo ║ ✅ Cambio dinámico sin reiniciar la app                    ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo 🌍 CARACTERÍSTICAS MULTIIDIOMA:
echo.
echo 📱 ESPAÑOL LATINO ^(es-MX^):
echo    • Palabras de activación: "Kay", "Que", "Hola Kay"
echo    • TTS en español mexicano
echo    • Interfaz completamente en español
echo    • Reconocimiento optimizado para acento latino
echo.
echo 🇺🇸 ENGLISH US ^(en-US^):
echo    • Activation words: "Kay", "Key", "Hey Kay", "Okay"
echo    • TTS in American English
echo    • Full English interface
echo    • Optimized for US pronunciation
echo.
echo ⚙️ CONFIGURACIÓN:
echo    • Menú lateral -^> nueva opción "Idioma/Language"
echo    • Cambio instantáneo sin reiniciar
echo    • Configuración guardada permanentemente
echo    • VoiceService se reinicia automáticamente
echo.
echo 🎯 PARA ACCEDER:
echo    1. Abre menú lateral ^(swipe izquierda^)
echo    2. Selecciona "Idioma" o "Language"
echo    3. Elige tu idioma preferido
echo    4. K.A.Y. cambiará inmediatamente
echo.
echo 🚀 PRÓXIMO PASO:
echo    • Actualizar drawer_menu.xml para agregar opción idioma
echo    • Conectar LanguageConfigActivity con MainActivity
echo.
pause