import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String url = "https://api.exchangerate-api.com/v4/latest/USD";

  static Future<double?> obtenerDolar() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["rates"]["EUR"]; // O puedes cambiar por tu moneda
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
