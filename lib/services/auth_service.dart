import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:memesv2/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String apiUrl = dotenv.env['API_URL']!;

  /// Método para iniciar sesion
  Future<AuthModel?> login(String email, String password) async {
    final url = Uri.parse('$apiUrl/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'ok' && data['message'] == 'success') {
        final auth = AuthModel.fromJson(data);

        // Guardar token y datos del usuario en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', auth.token);
        await prefs.setString(
            'userName', auth.name); // Guarda el nombre del usuario
        await prefs.setString(
            'userRole', auth.role); // Guarda el rol del usuario
        return auth;
      } else {
        return null; // Login fallido
      }
    } else {
      if (kDebugMode) {
        print('Error en la autenticación: ${response.statusCode}');
      }
      return null; // Error en el servidor o credenciales incorrectas
    }
  }

  /// Metodo para cerrar sesion
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final url = Uri.parse('$apiUrl/logout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token en el encabezado
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Limpiar los datos de sesion si el logout es exitoso
          await prefs.clear();
        } else {
          if (kDebugMode) {
            print('Error al cerrar sesion: ${data['message']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Error al cerrar sesion: ${response.statusCode}');
        }
      }
    } else {
      if (kDebugMode) {
        print('No se encontró el token para cerrar sesion.');
      }
    }
  }

  /// Método para obtener el token guardado
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
