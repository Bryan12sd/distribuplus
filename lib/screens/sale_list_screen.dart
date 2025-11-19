import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class SalesListScreen extends StatefulWidget {
  const SalesListScreen({super.key});

  @override
  State<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SalesListScreen> {
  List<Map<String, dynamic>> ventas = [];

  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  void initState() {
    super.initState();
    cargarVentas();
  }

  Future<int> usuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id") ?? 0;
  }

  Future<void> cargarVentas({bool conFiltro = false}) async {
    final db = await DatabaseHelper.instance.database;
    final userId = await usuarioActual();

    String where = "usuario_id = ?";
    List<dynamic> args = [userId];

    if (conFiltro && fechaInicio != null && fechaFin != null) {
      where += " AND fecha BETWEEN ? AND ?";
      args.add(fechaInicio!.toIso8601String());
      args.add(fechaFin!.toIso8601String());
    }

    final data = await db.rawQuery("""
      SELECT ventas.*, productos.nombre as producto_nombre
      FROM ventas
      INNER JOIN productos ON productos.id = ventas.producto_id
      WHERE $where
      ORDER BY fecha DESC
    """, args);

    setState(() {
      ventas = data;
    });
  }

  Future<void> seleccionarFechaInicio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => fechaInicio = picked);
    }
  }

  Future<void> seleccionarFechaFin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: fechaFin ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => fechaFin = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado de Ventas"),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtros de fecha
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: seleccionarFechaInicio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001F3F),
                    ),
                    child: Text(
                      fechaInicio == null
                          ? "Fecha Inicio"
                          : fechaInicio!.toString().substring(0, 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: seleccionarFechaFin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001F3F),
                    ),
                    child: Text(
                      fechaFin == null
                          ? "Fecha Fin"
                          : fechaFin!.toString().substring(0, 10),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                if (fechaInicio != null && fechaFin != null) {
                  cargarVentas(conFiltro: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Aplicar Filtros"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ventas.isEmpty
                  ? const Center(child: Text("No hay ventas registradas"))
                  : ListView.builder(
                      itemCount: ventas.length,
                      itemBuilder: (context, index) {
                        final venta = ventas[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              venta['producto_nombre'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "Cantidad: ${venta['cantidad']}\nFecha: ${venta['fecha']}"),
                            trailing: Text(
                              "\$${venta['total']}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
