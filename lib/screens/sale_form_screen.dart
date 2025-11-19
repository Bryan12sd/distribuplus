import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> productos = [];

  int? selectedProductId;
  int cantidad = 1;

  double precioUnitario = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('productos');

    setState(() {
      productos = data;
    });
  }

  void actualizarTotal() {
    setState(() {
      total = precioUnitario * cantidad;
    });
  }

  Future<int> usuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("user_id") ?? 0;
  }

  Future<void> registrarVenta() async {
    final db = await DatabaseHelper.instance.database;
    final usuarioId = await usuarioActual();

    await db.insert("ventas", {
      "producto_id": selectedProductId,
      "usuario_id": usuarioId,
      "fecha": DateTime.now().toString(),
      "cantidad": cantidad,
      "total": total,
    });

    await db.rawUpdate(
      "UPDATE productos SET cantidad = cantidad - ? WHERE id = ?",
      [cantidad, selectedProductId],
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Venta"),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: productos.isEmpty
            ? const Center(child: Text("No hay productos disponibles"))
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedProductId,
                      decoration: const InputDecoration(labelText: 'Producto'),
                      items: productos.map((producto) {
                        return DropdownMenuItem<int>(
                          value: producto['id'] as int,
                          child: Text(producto['nombre']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProductId = value;

                          // Buscar el producto y obtener el precio unitario
                          final selected = productos
                              .firstWhere((element) => element['id'] == value);

                          precioUnitario = double.tryParse(
                                  selected['precio_unitario'].toString()) ??
                              0;

                          actualizarTotal();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione un producto' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: "1",
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Cantidad"),
                      onChanged: (v) {
                        cantidad = int.tryParse(v) ?? 1;
                        actualizarTotal();
                      },
                      validator: (v) => v!.isEmpty ? "Ingrese cantidad" : null,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F3F),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001F3F),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registrarVenta();
                        }
                      },
                      child: const Text(
                        "Registrar Venta",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
