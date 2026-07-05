package com.agmgneila.ecomarket.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.adapter.CartAdapter
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.databinding.FragmentCartBinding
import com.google.android.material.snackbar.Snackbar

class CartFragment : Fragment() {
    private var _binding: FragmentCartBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, state: Bundle?): View {
        _binding = FragmentCartBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, state: Bundle?) {
        refresh()
        binding.checkoutButton.setOnClickListener {
            val total = DataSet.cartTotal()
            if (DataSet.cartItems().isEmpty()) {
                Snackbar.make(binding.root, R.string.empty_cart, Snackbar.LENGTH_LONG).show()
            } else {
                DataSet.clearCart()
                refresh()
                Snackbar.make(binding.root, getString(R.string.checkout_success, total), Snackbar.LENGTH_LONG).show()
            }
        }
    }

    private fun refresh() {
        binding.cartRecycler.layoutManager = LinearLayoutManager(requireContext())
        binding.cartRecycler.adapter = CartAdapter(DataSet.cartItems())
        binding.totalText.text = getString(R.string.total_format, DataSet.cartTotal())
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
