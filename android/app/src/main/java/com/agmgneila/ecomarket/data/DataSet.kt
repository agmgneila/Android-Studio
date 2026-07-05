package com.agmgneila.ecomarket.data

import com.agmgneila.ecomarket.model.Product
import com.agmgneila.ecomarket.model.User

object DataSet {
    private val users = arrayListOf(User("Admin", "admin@ecomarket.es", "admin"))
    private val cart = arrayListOf<Product>()
    private val favorites = hashSetOf<Long>()

    fun register(user: User): Boolean {
        if (users.any { it.email.equals(user.email, ignoreCase = true) }) return false
        return users.add(user)
    }

    fun login(email: String, password: String): User? =
        users.find { it.email.equals(email, true) && it.password == password }

    fun addToCart(product: Product) = cart.add(product)
    fun cartItems(): List<Product> = cart.toList()
    fun cartTotal(): Double = cart.sumOf { it.price }
    fun clearCart() = cart.clear()

    fun toggleFavorite(id: Long): Boolean =
        if (favorites.remove(id)) false else favorites.add(id).let { true }

    fun isFavorite(id: Long) = id in favorites
}

