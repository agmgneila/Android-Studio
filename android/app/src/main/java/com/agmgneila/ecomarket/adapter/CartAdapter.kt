package com.agmgneila.ecomarket.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.databinding.ItemCartBinding
import com.agmgneila.ecomarket.model.Product

class CartAdapter(private val products: List<Product>) :
    RecyclerView.Adapter<CartAdapter.CartHolder>() {
    inner class CartHolder(val binding: ItemCartBinding) : RecyclerView.ViewHolder(binding.root)
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = CartHolder(
        ItemCartBinding.inflate(LayoutInflater.from(parent.context), parent, false)
    )
    override fun onBindViewHolder(holder: CartHolder, position: Int) {
        holder.binding.cartTitle.text = products[position].title
        holder.binding.cartPrice.text =
            holder.itemView.context.getString(R.string.price_format, products[position].price)
    }
    override fun getItemCount() = products.size
}

