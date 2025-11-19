import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/api_service.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => ApiScreenState();
}

class ApiScreenState extends State<ApiScreen> {
  double? dolarValue;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDolar();
  }

  Future<void> cargarDolar() async {
    final valor = await ApiService.obtenerDolar();
    setState(() {
      dolarValue = valor;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cambio de Dólar"),
        backgroundColor: Color(0xFF001F3F),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: cargando
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Cotización del Dólar Hoy",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    dolarValue != null
                        ? "1 USD = $dolarValue EUR"
                        : "Error al cargar datos",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: cargarDolar,
                    child: const Text("Actualizar"),
                  )
                ],
              ),
      ),
    );
  }
}
