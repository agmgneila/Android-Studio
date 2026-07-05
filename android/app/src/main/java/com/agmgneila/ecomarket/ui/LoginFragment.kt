package com.agmgneila.ecomarket.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.databinding.FragmentLoginBinding
import com.google.android.material.snackbar.Snackbar

class LoginFragment : Fragment() {
    private var _binding: FragmentLoginBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, state: Bundle?): View {
        _binding = FragmentLoginBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, state: Bundle?) {
        binding.emailEdit.setText("admin@ecomarket.es")
        binding.passwordEdit.setText("admin")
        binding.loginButton.setOnClickListener {
            val user = DataSet.login(binding.emailEdit.text.toString(), binding.passwordEdit.text.toString())
            if (user != null) findNavController().navigate(R.id.action_login_to_catalog)
            else Snackbar.make(binding.root, R.string.login_error, Snackbar.LENGTH_LONG).show()
        }
        binding.registerButton.setOnClickListener {
            findNavController().navigate(R.id.action_login_to_register)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

