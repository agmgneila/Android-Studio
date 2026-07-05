package com.agmgneila.ecomarket.data

import com.agmgneila.ecomarket.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.FirebaseDatabase

/**
 * Adaptador opcional del Tema 6. Necesita un proyecto Firebase configurado.
 * La app usa DataSet por defecto para poder ejecutarse sin credenciales.
 */
class FirebaseAuthGateway(
    private val auth: FirebaseAuth,
    private val database: FirebaseDatabase
) {
    fun register(user: User, callback: (Boolean) -> Unit) {
        auth.createUserWithEmailAndPassword(user.email, user.password)
            .addOnCompleteListener { result ->
                if (!result.isSuccessful) {
                    callback(false)
                    return@addOnCompleteListener
                }
                database.reference.child("users").child(auth.currentUser!!.uid)
                    .setValue(user.copy(password = ""))
                    .addOnCompleteListener { callback(it.isSuccessful) }
            }
    }

    fun login(email: String, password: String, callback: (Boolean) -> Unit) {
        auth.signInWithEmailAndPassword(email, password)
            .addOnCompleteListener { callback(it.isSuccessful) }
    }
}

