package com.agmgneila.ecomarket.adapter

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.databinding.ItemProductBinding
import com.agmgneila.ecomarket.model.Product
import com.bumptech.glide.Glide

class ProductAdapter(
    private val onDetail: (Product) -> Unit,
    private val onCart: (Product) -> Unit
) : RecyclerView.Adapter<ProductAdapter.ProductHolder>() {
    private val allProducts = arrayListOf<Product>()
    private val visibleProducts = arrayListOf<Product>()

    inner class ProductHolder(val binding: ItemProductBinding) :
        RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) = ProductHolder(
        ItemProductBinding.inflate(LayoutInflater.from(parent.context), parent, false)
    )

    override fun onBindViewHolder(holder: ProductHolder, position: Int) {
        val product = visibleProducts[position]
        with(holder.binding) {
            productTitle.text = product.title
            productCategory.text = product.category
            productPrice.text = root.context.getString(R.string.price_format, product.price)
            Glide.with(root).load(product.thumbnail).placeholder(R.drawable.product_placeholder)
                .into(productImage)
            detailButton.setOnClickListener { onDetail(product) }
            cartButton.setOnClickListener { onCart(product) }
            favoriteButton.setImageResource(
                if (DataSet.isFavorite(product.id)) R.drawable.ic_favorite
                else R.drawable.ic_favorite_border
            )
            favoriteButton.setOnClickListener {
                DataSet.toggleFavorite(product.id)
                notifyItemChanged(position)
            }
        }
    }

    override fun getItemCount() = visibleProducts.size

    fun submit(products: List<Product>) {
        allProducts.clear()
        allProducts.addAll(products)
        filter("")
    }

    fun filter(query: String) {
        visibleProducts.clear()
        visibleProducts.addAll(allProducts.filter {
            it.title.contains(query, true) || it.category.contains(query, true)
        })
        notifyDataSetChanged()
    }
}

