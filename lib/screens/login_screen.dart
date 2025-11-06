import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (_emailController.text == savedEmail &&
        _passwordController.text == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('DistribuPlus',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F))),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Correo', border: OutlineInputBorder()),
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
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
