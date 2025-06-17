package com.kay.assistant.services

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.google.android.gms.auth.api.identity.BeginSignInRequest
import com.google.android.gms.auth.api.identity.Identity
import com.google.android.gms.auth.api.identity.SignInClient
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.GoogleAuthProvider

class ChatGPTLoginService(private val activity: Activity) {

    private val firebaseAuth: FirebaseAuth = FirebaseAuth.getInstance()
    private val oneTapClient: SignInClient = Identity.getSignInClient(activity)

    private val signInRequest: BeginSignInRequest = BeginSignInRequest.builder()
        .setGoogleIdTokenRequestOptions(
            BeginSignInRequest.GoogleIdTokenRequestOptions.builder()
                .setSupported(true)
                .setServerClientId("1018780639010-o41d9vjqjopkghmftdb1lv4n0pte14lk.apps.googleusercontent.com") // <--- REEMPLAZA AQUÍ SI CAMBIA
                .setFilterByAuthorizedAccounts(false)
                .build()
        )
        .setAutoSelectEnabled(true)
        .build()

    fun launchLogin(callback: (Boolean, String?) -> Unit) {
        oneTapClient.beginSignIn(signInRequest)
            .addOnSuccessListener { result ->
                try {
                    activity.startIntentSenderForResult(
                        result.pendingIntent.intentSender,
                        RC_ONE_TAP,
                        null,
                        0, 0, 0, null
                    )
                } catch (e: Exception) {
                    callback(false, "Login intent failed: ${e.message}")
                }
            }
            .addOnFailureListener {
                callback(false, "Sign-in initiation failed: ${it.message}")
            }
    }

    fun handleLoginResult(data: Intent?, callback: (Boolean, String?) -> Unit) {
        oneTapClient.getSignInCredentialFromIntent(data).let { credential ->
            val idToken = credential.googleIdToken
            if (idToken != null) {
                val firebaseCredential = GoogleAuthProvider.getCredential(idToken, null)
                firebaseAuth.signInWithCredential(firebaseCredential)
                    .addOnCompleteListener { task: Task<*> ->
                        if (task.isSuccessful) {
                            callback(true, null)
                        } else {
                            callback(false, task.exception?.message)
                        }
                    }
            } else {
                callback(false, "No ID token found")
            }
        }
    }

    companion object {
        const val RC_ONE_TAP = 100
    }
}
