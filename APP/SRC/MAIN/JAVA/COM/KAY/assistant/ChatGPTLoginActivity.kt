package com.kay.assistant

import android.content.Intent
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.EditText
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.auth.api.identity.BeginSignInRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.auth.api.identity.SignInClient
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider

class ChatGPTLoginActivity : AppCompatActivity() {

    private lateinit var auth: FirebaseAuth
    private lateinit var oneTapClient: SignInClient
    private lateinit var signInRequest: BeginSignInRequest

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        auth = FirebaseAuth.getInstance()

        // Si ya está logueado, lo enviamos al MainActivity directamente
        auth.currentUser?.let {
            startActivity(Intent(this, MainActivity::class.java))
            finish()
            return
        }

        initOneTap()

        showLoginDialog()
    }

    private fun initOneTap() {
        oneTapClient = Identity.getSignInClient(this)
        signInRequest = BeginSignInRequest.builder()
            .setGoogleIdTokenRequestOptions(
                BeginSignInRequest.GoogleIdTokenRequestOptions.builder()
                    .setSupported(true)
                    .setServerClientId(getString(R.string.default_web_client_id)) // <- Este está en google-services.json
                    .setFilterByAuthorizedAccounts(false)
                    .build()
            )
            .setAutoSelectEnabled(true)
            .build()

        oneTapClient.beginSignIn(signInRequest)
            .addOnSuccessListener { result ->
                startIntentSenderForResult(
                    result.pendingIntent.intentSender,
                    RC_ONE_TAP,
                    null, 0, 0, 0
                )
            }
            .addOnFailureListener {
                Snackbar.make(findViewById(android.R.id.content), "Error al iniciar sesión: ${it.message}", Snackbar.LENGTH_LONG).show()
            }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == RC_ONE_TAP) {
            val credential = Identity.getSignInClient(this).getSignInCredentialFromIntent(data)
            val idToken = credential.googleIdToken
            if (idToken != null) {
                val firebaseCredential = GoogleAuthProvider.getCredential(idToken, null)
                auth.signInWithCredential(firebaseCredential)
                    .addOnCompleteListener { task ->
                        if (task.isSuccessful) {
                            startActivity(Intent(this, MainActivity::class.java))
                            finish()
                        } else {
                            Snackbar.make(findViewById(android.R.id.content), "Fallo en la autenticación", Snackbar.LENGTH_LONG).show()
                        }
                    }
            }
        }
    }

    private fun showLoginDialog() {
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(60, 50, 60, 50)
        }

        val titleText = TextView(this).apply {
            text = "🔐 Conectando con ChatGPT..."
            textSize = 22f
            setPadding(0, 0, 0, 30)
            gravity = android.view.Gravity.CENTER
        }

        layout.addView(titleText)

        setContentView(layout)
    }

    companion object {
        private const val RC_ONE_TAP = 100
    }
}
