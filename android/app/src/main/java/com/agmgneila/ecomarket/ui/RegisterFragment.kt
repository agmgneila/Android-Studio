package com.agmgneila.ecomarket.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.agmgneila.ecomarket.R
import com.agmgneila.ecomarket.data.DataSet
import com.agmgneila.ecomarket.databinding.FragmentRegisterBinding
import com.agmgneila.ecomarket.model.User
import com.google.android.material.snackbar.Snackbar

class RegisterFragment : Fragment() {
    private var _binding: FragmentRegisterBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, state: Bundle?): View {
        _binding = FragmentRegisterBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, state: Bundle?) {
        binding.registerButton.setOnClickListener {
            val name = binding.nameEdit.text.toString().trim()
            val email = binding.emailEdit.text.toString().trim()
            val password = binding.passwordEdit.text.toString()
            if (name.length < 2 || !email.contains("@") || password.length < 4) {
                Snackbar.make(binding.root, R.string.form_error, Snackbar.LENGTH_LONG).show()
            } else if (DataSet.register(User(name, email, password))) {
                Snackbar.make(binding.root, R.string.register_success, Snackbar.LENGTH_LONG)
                    .setAction(R.string.login) { findNavController().navigateUp() }.show()
            } else {
                Snackbar.make(binding.root, R.string.duplicated_user, Snackbar.LENGTH_LONG).show()
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}

