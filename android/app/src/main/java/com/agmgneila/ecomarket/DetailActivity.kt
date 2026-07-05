package com.agmgneila.ecomarket

import android.os.Build
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.databinding.ActivityDetailBinding
import com.agmgneila.ecomarket.model.Product
import com.bumptech.glide.Glide
import com.google.android.material.snackbar.Snackbar

class DetailActivity : AppCompatActivity() {
    private lateinit var binding: ActivityDetailBinding
    private lateinit var product: Product

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDetailBinding.inflate(layoutInflater)
        setContentView(binding.root)
        product = if (Build.VERSION.SDK_INT >= 33) {
            intent.getSerializableExtra(EXTRA_PRODUCT, Product::class.java)!!
        } else {
            @Suppress("DEPRECATION")
            intent.getSerializableExtra(EXTRA_PRODUCT) as Product
        }
        title = product.title
        binding.detailTitle.text = product.title
        binding.detailDescription.text = product.description
        binding.detailPrice.text = getString(R.string.price_format, product.price)
        binding.detailRating.text = getString(R.string.rating_format, product.rating)
        Glide.with(this).load(product.thumbnail).placeholder(R.drawable.product_placeholder)
            .into(binding.detailImage)
        binding.addCartButton.setOnClickListener {
            DataSet.addToCart(product)
            Snackbar.make(binding.root, R.string.added_to_cart, Snackbar.LENGTH_LONG).show()
        }
    }

    companion object { const val EXTRA_PRODUCT = "product" }
}

