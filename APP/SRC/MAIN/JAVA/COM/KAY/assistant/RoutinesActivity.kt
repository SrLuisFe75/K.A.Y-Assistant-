package com.kay.assistant

import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AlertDialog

class RoutinesActivity : AppCompatActivity() {
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showRoutinesDialog()
    }

    private fun showRoutinesDialog() {
        val routines = arrayOf(
            "🌅 Buenos días - Saludo matutino",
            "🌙 Buenas noches - Despedida nocturna", 
            "⏰ Recordatorios - Alarmas y avisos",
            "📱 Modo trabajo - Configuración productiva",
            "🎵 Modo relajación - Ambiente tranquilo",
            "🚗 Modo conducción - Respuestas por voz"
        )
        
        AlertDialog.Builder(this)
            .setTitle("🔄 Rutinas de K.A.Y.")
            .setItems(routines) { _, which ->
                val selectedRoutine = routines[which]
                Toast.makeText(this, "Rutina activada: $selectedRoutine", Toast.LENGTH_LONG).show()
                
                // Aquí iría la lógica específica de cada rutina
                when(which) {
                    0 -> activateMorningRoutine()
                    1 -> activateNightRoutine()
                    2 -> activateReminders()
                    3 -> activateWorkMode()
                    4 -> activateRelaxMode()
                    5 -> activateDrivingMode()
                }
                
                finish()
            }
            .setNegativeButton("Cancelar") { _, _ ->
                finish()
            }
            .show()
    }
    
    private fun activateMorningRoutine() {
        Toast.makeText(this, "🌅 Buenos días! K.A.Y. listo para comenzar el día", Toast.LENGTH_LONG).show()
    }
    
    private fun activateNightRoutine() {
        Toast.makeText(this, "🌙 Buenas noches! K.A.Y. en modo silencioso", Toast.LENGTH_LONG).show()
    }
    
    private fun activateReminders() {
        Toast.makeText(this, "⏰ Recordatorios activados", Toast.LENGTH_SHORT).show()
    }
    
    private fun activateWorkMode() {
        Toast.makeText(this, "📱 Modo trabajo activado", Toast.LENGTH_SHORT).show()
    }
    
    private fun activateRelaxMode() {
        Toast.makeText(this, "🎵 Modo relajación activado", Toast.LENGTH_SHORT).show()
    }
    
    private fun activateDrivingMode() {
        Toast.makeText(this, "🚗 Modo conducción activado", Toast.LENGTH_SHORT).show()
    }
}