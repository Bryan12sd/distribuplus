import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? producto;

  const ProductFormScreen({super.key, this.producto});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();
  final precioCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.producto != null) {
      nombreCtrl.text = widget.producto!['nombre'];
      cantidadCtrl.text = widget.producto!['cantidad'].toString();
      precioCtrl.text = widget.producto!['precio_unitario'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.producto == null ? "Agregar Producto" : "Editar Producto"),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) => v!.isEmpty ? "Ingrese un nombre" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Cantidad"),
                validator: (v) => v!.isEmpty ? "Ingrese una cantidad" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: precioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Precio unitario"),
                validator: (v) => v!.isEmpty ? "Ingrese un precio" : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001F3F),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final db = await DatabaseHelper.instance.database;

                    final data = {
                      "nombre": nombreCtrl.text,
                      "cantidad": int.parse(cantidadCtrl.text),
                      "precio_unitario": double.parse(precioCtrl.text),
                    };

                    if (widget.producto == null) {
                      await db.insert("productos", data);
                    } else {
                      await db.update(
                        "productos",
                        data,
                        where: "id = ?",
                        whereArgs: [widget.producto!['id']],
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.producto == null ? "Guardar" : "Actualizar",
                    style: const TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
