import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.person, size: 100, color: Color(0xFF001F3F)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F3F)),
              child: const Text('Guardar cambios'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
