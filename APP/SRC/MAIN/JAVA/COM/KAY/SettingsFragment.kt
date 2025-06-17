package com.kay.assistant

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment

class SettingsFragment : Fragment() {
    private val PERMISSIONS_REQUEST_CODE = 123

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_settings, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // Configurar listeners para los botones
        view.findViewById<View>(R.id.btn_microphone).setOnClickListener {
            requestMicrophonePermission()
        }

        view.findViewById<View>(R.id.btn_storage).setOnClickListener {
            requestStoragePermission()
        }

        view.findViewById<View>(R.id.btn_system).setOnClickListener {
            openSystemSettings()
        }

        view.findViewById<View>(R.id.btn_voice).setOnClickListener {
            openVoiceSettings()
        }

        view.findViewById<View>(R.id.btn_notifications).setOnClickListener {
            openNotificationSettings()
        }
    }

    private fun requestMicrophonePermission() {
        if (ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                requireActivity(),
                arrayOf(Manifest.permission.RECORD_AUDIO),
                PERMISSIONS_REQUEST_CODE
            )
        } else {
            Toast.makeText(context, "Permiso de micrófono ya concedido", Toast.LENGTH_SHORT).show()
        }
    }

    private fun requestStoragePermission() {
        if (ContextCompat.checkSelfPermission(
                requireContext(),
                Manifest.permission.WRITE_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                requireActivity(),
                arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                PERMISSIONS_REQUEST_CODE
            )
        } else {
            Toast.makeText(context, "Permiso de almacenamiento ya concedido", Toast.LENGTH_SHORT).show()
        }
    }

    private fun openSystemSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        val uri = Uri.fromParts("package", requireActivity().packageName, null)
        intent.data = uri
        startActivity(intent)
    }

    private fun openVoiceSettings() {
        val intent = Intent(Settings.ACTION_VOICE_INPUT_SETTINGS)
        startActivity(intent)
    }

    private fun openNotificationSettings() {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
        intent.putExtra(Settings.EXTRA_APP_PACKAGE, requireActivity().packageName)
        startActivity(intent)
    }
} 