package com.agmgneila.ecomarket.ui

import android.content.Intent
import android.content.res.Configuration
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import com.agmgneila.ecomarket.DetailActivity
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.adapter.ProductAdapter
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.data.ProductRepository
import com.agmgneila.ecomarket.databinding.FragmentCatalogBinding
import com.google.android.material.snackbar.Snackbar

class CatalogFragment : Fragment() {
    private var _binding: FragmentCatalogBinding? = null
    private val binding get() = _binding!!
    private lateinit var adapter: ProductAdapter

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, state: Bundle?): View {
        _binding = FragmentCatalogBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, state: Bundle?) {
        adapter = ProductAdapter(
            onDetail = { product ->
                startActivity(Intent(requireContext(), DetailActivity::class.java)
                    .putExtra(DetailActivity.EXTRA_PRODUCT, product))
            },
            onCart = { product ->
                DataSet.addToCart(product)
                Snackbar.make(binding.root, R.string.added_to_cart, Snackbar.LENGTH_SHORT).show()
            }
        )
        binding.productRecycler.adapter = adapter
        binding.productRecycler.layoutManager =
            if (resources.configuration.orientation == Configuration.ORIENTATION_LANDSCAPE)
                GridLayoutManager(requireContext(), 2)
            else LinearLayoutManager(requireContext())
        binding.searchEdit.doAfterTextChanged { adapter.filter(it.toString()) }
        binding.cartButton.setOnClickListener {
            findNavController().navigate(R.id.action_catalog_to_cart)
        }
        ProductRepository(requireContext()).getProducts(
            onSuccess = adapter::submit,
            onError = {
                adapter.submit(ProductRepository.fallback())
                Snackbar.make(binding.root, R.string.offline_catalog, Snackbar.LENGTH_LONG).show()
            }
        )
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

