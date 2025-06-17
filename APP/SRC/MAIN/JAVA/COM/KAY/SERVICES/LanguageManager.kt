package com.kay.services

import android.content.Context
import android.content.SharedPreferences
import java.util.Locale

class LanguageManager(private val context: Context) {
    private val prefs: SharedPreferences = context.getSharedPreferences("language_config", Context.MODE_PRIVATE)
    
    companion object {
        const val SPANISH_LATINO = "es-MX"
        const val ENGLISH_US = "en-US"
        const val DEFAULT_LANGUAGE = SPANISH_LATINO
    }

    fun getCurrentLanguage(): String {
        return prefs.getString("selected_language", DEFAULT_LANGUAGE) ?: DEFAULT_LANGUAGE
    }

    fun setLanguage(languageCode: String) {
        prefs.edit().putString("selected_language", languageCode).apply()
    }

    fun getAvailableLanguages(): List<Pair<String, String>> {
        return listOf(
            Pair(SPANISH_LATINO, "Español (Latino)"),
            Pair(ENGLISH_US, "English (US)")
        )
    }

    fun getTTSLanguage(): Locale {
        return when(getCurrentLanguage()) {
            ENGLISH_US -> Locale("en", "US")
            else -> Locale("es", "MX")
        }
    }
}