import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('password', _passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro exitoso, ahora inicia sesión')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Crear cuenta',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF001F3F))),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Nombre completo', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Correo', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Teléfono', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Contraseña', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001F3F)),
                onPressed: _register,
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
