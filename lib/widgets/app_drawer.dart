import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
/* import '../screens/inventory_screen.dart';
import '../screens/sales_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/map_screen.dart'; */
import '../screens/profile_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/sale_form_screen.dart';
import '../screens/sale_list_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF001F3F),
            ),
            child: Text(
              'DistribuPlus',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(context, Icons.home, 'Inicio', const HomeScreen()),
          _drawerItem(context, Icons.inventory, 'Inventario',
              const ProductListScreen()),
          _drawerItem(
              context, Icons.shopping_cart, 'Ventas', const SalesListScreen()),
          _drawerItem(context, Icons.bar_chart, 'Registrar Venta',
              const SaleFormScreen()),
          /* _drawerItem(context, Icons.map, 'Mapa', const MapScreen()), */
          _drawerItem(context, Icons.person, 'Perfil', const ProfileScreen()),
        ],
      ),
    );
  }

  ListTile _drawerItem(
      BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF001F3F)),
      title: Text(title),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
