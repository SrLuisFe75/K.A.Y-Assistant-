package com.kay.assistant

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AlertDialog
import com.kay.services.LanguageManager

class LanguageConfigActivity : AppCompatActivity() {
    
    private lateinit var languageManager: LanguageManager
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        languageManager = LanguageManager(this)
        showLanguageDialog()
    }

    private fun showLanguageDialog() {
        val languages = languageManager.getAvailableLanguages()
        val currentLanguage = languageManager.getCurrentLanguage()
        val currentIndex = languages.indexOfFirst { it.first == currentLanguage }
        
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(60, 50, 60, 50)
        }
        
        val titleText = TextView(this).apply {
            text = "🌍 Seleccionar Idioma / Select Language"
            textSize = 20f
            setPadding(0, 0, 0, 30)
            gravity = android.view.Gravity.CENTER
        }
        layout.addView(titleText)
        
        val radioGroup = RadioGroup(this)
        
        languages.forEachIndexed { index, (code, name) ->
            val radioButton = RadioButton(this).apply {
                text = name
                id = index
                isChecked = (index == currentIndex)
                setPadding(20, 10, 20, 10)
                textSize = 16f
            }
            radioGroup.addView(radioButton)
        }
        
        layout.addView(radioGroup)
        
        AlertDialog.Builder(this)
            .setView(layout)
            .setTitle("Language / Idioma")
            .setPositiveButton("✅ Aplicar / Apply") { _, _ ->
                val selectedIndex = radioGroup.checkedRadioButtonId
                if (selectedIndex != -1 && selectedIndex < languages.size) {
                    val selectedLanguage = languages[selectedIndex].first
                    applyLanguage(selectedLanguage)
                }
            }
            .setNegativeButton("❌ Cancelar / Cancel") { _, _ ->
                setResult(Activity.RESULT_CANCELED)
                finish()
            }
            .setCancelable(false)
            .show()
    }

    private fun applyLanguage(languageCode: String) {
        languageManager.setLanguage(languageCode)
        
        val message = when(languageCode) {
            LanguageManager.ENGLISH_US -> "Language changed to English (US)"
            else -> "Idioma cambiado a Español (Latino)"
        }
        
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
        
        val intent = Intent("com.kay.assistant.LANGUAGE_CHANGED")
        intent.putExtra("language", languageCode)
        sendBroadcast(intent)
        
        setResult(Activity.RESULT_OK)
        finish()
    }
}