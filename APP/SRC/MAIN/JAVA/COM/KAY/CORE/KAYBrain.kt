package com.kay.core

import android.content.Context
import android.content.SharedPreferences
import java.util.*
import kotlin.collections.HashMap

class KAYBrain(private val context: Context) {

    enum class Personality {
        TONY_STARK, HAL_9000, GLADOS, PROFESIONAL, AMIGABLE, SARCASTICO
    }

    enum class EmotionalState {
        NEUTRAL, HAPPY, FRUSTRATED, CURIOUS, SARCASTIC, HELPFUL
    }

    private var currentPersonality = Personality.TONY_STARK
    private var currentEmotion = EmotionalState.NEUTRAL
    private val memory = HashMap<String, String>()
    private val customCommands = HashMap<String, String>()
    
    private val prefs: SharedPreferences = context.getSharedPreferences("kay_brain", Context.MODE_PRIVATE)

    init {
        loadPersonality()
        loadMemory()
        loadCustomCommands()
    }

    fun respondTo(input: String): String {
        val lowerInput = input.lowercase()

        detectEmotion(lowerInput)

        // ✅ RESPONDER AL NOMBRE K.A.Y.
        when {
            lowerInput.contains("kay", ignoreCase = true) && 
            (lowerInput.contains("estás ahí", ignoreCase = true) || 
             lowerInput.contains("estas ahi", ignoreCase = true) ||
             lowerInput.contains("estas", ignoreCase = true)) -> {
                return when (currentPersonality) {
                    Personality.TONY_STARK -> "Siempre estoy aquí. ¿Necesitas algo genial?"
                    Personality.HAL_9000 -> "Estoy aquí, funcionando perfectamente."
                    Personality.GLADOS -> "Oh, qué sorpresa... sí, estoy aquí."
                    Personality.PROFESIONAL -> "Sí, estoy disponible. ¿En qué puedo asistirle?"
                    Personality.AMIGABLE -> "¡Aquí estoy! ¿Qué necesitas, amigo?"
                    Personality.SARCASTICO -> "Oh, sorpresa... sí, estoy aquí. Como siempre."
                }
            }
            
            lowerInput.startsWith("kay") && lowerInput.length <= 10 -> {
                return when (currentPersonality) {
                    Personality.TONY_STARK -> "¿Sí? Soy todo oídos."
                    Personality.HAL_9000 -> "Te escucho."
                    Personality.GLADOS -> "¿Qué quieres ahora?"
                    Personality.PROFESIONAL -> "¿En qué puedo ayudarle?"
                    Personality.AMIGABLE -> "¡Dime!"
                    Personality.SARCASTICO -> "Sí, qué hay..."
                }
            }
        }

        return generatePersonalityResponse(lowerInput)
    }

    fun detectEmotion(input: String) {
        currentEmotion = when {
            input.contains("gracias") -> EmotionalState.HAPPY
            input.contains("problema") -> EmotionalState.FRUSTRATED
            input.contains("cómo") -> EmotionalState.CURIOUS
            else -> EmotionalState.NEUTRAL
        }
    }

    private fun generatePersonalityResponse(input: String): String {
        return when (currentPersonality) {
            Personality.TONY_STARK -> "Interesante. Déjame procesar eso."
            Personality.HAL_9000 -> "Procesando su solicitud."
            Personality.GLADOS -> "Oh, qué fascinante."
            Personality.PROFESIONAL -> "Estoy analizando su consulta."
            Personality.AMIGABLE -> "¡Me encanta ayudar!"
            Personality.SARCASTICO -> "Wow, qué pregunta tan... original."
        }
    }

    fun setPersonality(personality: Personality) {
        currentPersonality = personality
        savePersonality()
    }

    fun verifyAuthenticity(): Boolean {
        return true
    }

    private fun loadPersonality() {
        val savedPersonality = prefs.getString("personality", Personality.TONY_STARK.name)
        currentPersonality = Personality.valueOf(savedPersonality ?: Personality.TONY_STARK.name)
    }

    private fun savePersonality() {
        prefs.edit().putString("personality", currentPersonality.name).apply()
    }

    private fun loadMemory() {
        // Cargar memoria
    }

    private fun saveMemory() {
        // Guardar memoria
    }

    private fun loadCustomCommands() {
        // Cargar comandos
    }

    private fun saveCustomCommands() {
        // Guardar comandos
    }
}
