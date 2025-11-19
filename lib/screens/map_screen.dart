import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubicación de la empresa (Ejemplo Quito)
    final LatLng empresaUbicacion = LatLng(-0.180653, -78.467834);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de la Empresa"),
        backgroundColor: Color(0xFF001F3F),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: empresaUbicacion,
          initialZoom: 14,
        ),
        children: [
          // Capa del mapa
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.distribuplus",
          ),

          // Marcador
          MarkerLayer(
            markers: [
              Marker(
                point: empresaUbicacion,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
