package com.kay.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.speech.tts.TextToSpeech
import android.util.Log
import java.util.Locale

class VoiceService : Service(), RecognitionListener, TextToSpeech.OnInitListener {
    companion object {
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "KAYVoiceChannel"
    }

    private var speechRecognizer: SpeechRecognizer? = null
    private var textToSpeech: TextToSpeech? = null
    private var isListening = false

    override fun onCreate() {
        super.onCreate()
        Log.d("KAY", "VoiceService iniciando...")
        createNotificationChannel()
        textToSpeech = TextToSpeech(this, this)
        initializeSpeechRecognizer()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(NOTIFICATION_ID, createNotification())
        startListening()
        return START_STICKY
    }

    private fun initializeSpeechRecognizer() {
        speechRecognizer = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val googleComponent = ComponentName(
                "com.google.android.googlequicksearchbox",
                "com.google.android.voicesearch.serviceapi.GoogleRecognitionService"
            )
            SpeechRecognizer.createSpeechRecognizer(this, googleComponent)
        } else {
            SpeechRecognizer.createSpeechRecognizer(this)
        }
        speechRecognizer?.setRecognitionListener(this)
    }

    private fun startListening() {
        if (isListening || speechRecognizer == null) return
        
        val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
            putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            putExtra(RecognizerIntent.EXTRA_LANGUAGE, "es-MX")
            putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
            putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 1000)
        }
        
        speechRecognizer?.startListening(intent)
        isListening = true
        Log.d("KAY", "Iniciando escucha...")
    }

    override fun onResults(results: Bundle?) {
        val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
        matches?.firstOrNull()?.let { recognizedText ->
            Log.d("KAY", "Texto reconocido: $recognizedText")
            processVoiceCommand(recognizedText)
        }
        isListening = false
        Handler(Looper.getMainLooper()).postDelayed({ startListening() }, 100)
    }

    private fun processVoiceCommand(text: String) {
        if (text.contains("kay", ignoreCase = true) || text.contains("key", ignoreCase = true)) {
            val response = "Hola, soy K.A.Y. ¿En qué puedo ayudarte?"
            speak(response)
            updateHUD("K.A.Y. responde: $response")
        }
    }

    private fun speak(text: String) {
        textToSpeech?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "kay_response")
        Log.d("KAY", "K.A.Y. dice: $text")
    }

    private fun updateHUD(message: String) {
        val intent = Intent("com.kay.assistant.UPDATE_HUD").apply {
            putExtra("response", message)
        }
        sendBroadcast(intent)
    }

    override fun onInit(status: Int) {
        if (status == TextToSpeech.SUCCESS) {
            textToSpeech?.language = Locale("es", "MX")
            speak("K.A.Y. Assistant está listo")
            Log.d("KAY", "TTS inicializado correctamente")
        }
    }

    override fun onError(error: Int) {
        Log.w("KAY", "Error en reconocimiento: $error")
        isListening = false
        if (error != SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS) {
            Handler(Looper.getMainLooper()).postDelayed({ startListening() }, 500)
        }
    }

    override fun onReadyForSpeech(params: Bundle?) {
        Log.d("KAY", "Listo para escuchar")
    }
    override fun onBeginningOfSpeech() {}
    override fun onRmsChanged(rmsdB: Float) {}
    override fun onBufferReceived(buffer: ByteArray?) {}
    override fun onEndOfSpeech() {}
    override fun onPartialResults(partialResults: Bundle?) {}
    override fun onEvent(eventType: Int, params: Bundle?) {}

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "K.A.Y. Voice Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("K.A.Y. Assistant")
                .setContentText("Escuchando... Di 'Kay'")
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setOngoing(true)
                .build()
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
                .setContentTitle("K.A.Y. Assistant")
                .setContentText("Escuchando... Di 'Kay'")
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .setOngoing(true)
                .build()
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}