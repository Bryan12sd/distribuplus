import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../database/database_helper.dart';
import 'sale_form_screen.dart';
import 'product_form_screen.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int productosBajoStock = 0;
  int ventasHoy = 0;
  double dolar = 0.0;
  List<Map<String, dynamic>> ultimasVentas = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    await cargarProductosBajoStock();
    await cargarVentasHoy();

    await cargarUltimasVentas();
  }

  Future<void> cargarProductosBajoStock() async {
    final db = await DatabaseHelper.instance.database;
    final resultado = await db
        .rawQuery('SELECT COUNT(*) as total FROM productos WHERE cantidad < 5');
    setState(() {
      productosBajoStock = resultado.first['total'] as int;
    });
  }

  Future<void> cargarVentasHoy() async {
    final db = await DatabaseHelper.instance.database;
    final hoy = DateTime.now();
    final resultado = await db.rawQuery(
      'SELECT COUNT(*) as total FROM ventas WHERE DATE(fecha) = ?',
      [hoy.toIso8601String().substring(0, 10)],
    );
    setState(() {
      ventasHoy = resultado.first['total'] as int;
    });
  }

  Future<void> cargarUltimasVentas() async {
    final db = await DatabaseHelper.instance.database;
    final resultado = await db.query(
      'ventas',
      orderBy: 'fecha DESC',
      limit: 5,
    );
    setState(() {
      ultimasVentas = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: cargarDatos,
          child: ListView(
            children: [
              const Text(
                '¡Bienvenido!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F)),
              ),
              const SizedBox(height: 20),

              // Cards de información

              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.store, color: Colors.blue),
                  title: const Text('Productos con stock bajo'),
                  subtitle: Text('$productosBajoStock productos'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.receipt, color: Colors.blue),
                  title: const Text('Ventas de hoy'),
                  subtitle: Text('$ventasHoy ventas registradas'),
                ),
              ),
              const SizedBox(height: 20),

              // Botones rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001F3F)),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SaleFormScreen()),
                      );
                      cargarDatos(); // Actualiza después de volver
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Registrar Venta'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001F3F)),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProductFormScreen()),
                      );
                      cargarDatos(); // Actualiza después de volver
                    },
                    icon: const Icon(Icons.add_box),
                    label: const Text('Agregar Producto'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Últimas ventas
              const Text(
                'Últimas ventas',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F)),
              ),
              const SizedBox(height: 10),
              ultimasVentas.isEmpty
                  ? const Text('No hay ventas registradas')
                  : Column(
                      children: ultimasVentas.map((venta) {
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            title: Text('Producto ID: ${venta['producto_id']}'),
                            subtitle: Text(
                                'Cantidad: ${venta['cantidad']}, Total: \$${venta['total']}'),
                            trailing: Text(
                                venta['fecha'].toString().substring(0, 10)),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
