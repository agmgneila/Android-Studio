package com.agmgneila.ecomarket.data

import android.content.Context
import com.agmgneila.ecomarket.model.Product
import com.agmgneila.ecomarket.model.ProductResponse
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.google.gson.Gson

class ProductRepository(context: Context) {
    private val queue = Volley.newRequestQueue(context.applicationContext)

    fun getProducts(onSuccess: (List<Product>) -> Unit, onError: () -> Unit) {
        val request = JsonObjectRequest(
            "https://dummyjson.com/products?limit=30",
            { response ->
                onSuccess(Gson().fromJson(response.toString(), ProductResponse::class.java).products)
            },
            { onError() }
        )
        queue.add(request)
    }

    companion object {
        fun fallback() = listOf(
            Product(101, "Botella reutilizable", "Acero reciclado, 750 ml", "hogar", 18.90, 4.8),
            Product(102, "Mochila urbana", "Tejido recuperado y resistente", "accesorios", 42.50, 4.6),
            Product(103, "Cuaderno semilla", "Papel reciclado que se puede plantar", "papelería", 9.95, 4.9)
        )
    }
}

