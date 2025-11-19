import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> productos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('productos', orderBy: "id DESC");

    setState(() {
      productos = data;
      loading = false;
    });
  }

  Future<void> eliminarProducto(int id) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );

    cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventario"),
        backgroundColor: const Color(0xFF001F3F),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
          cargarProductos();
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? const Center(
                  child: Text(
                    "No hay productos registrados",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (_, index) {
                    final p = productos[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Text(
                          p['nombre'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Cantidad: ${p['cantidad']}  |  Precio: \$${p['precio_unitario']}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductFormScreen(producto: p),
                                ),
                              );
                              cargarProductos();
                            } else if (value == 'delete') {
                              eliminarProducto(p['id']);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Editar"),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text("Eliminar"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
