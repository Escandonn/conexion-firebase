import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:memesv2/models/category.dart';

class CategoryService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Metodo para obtener la lista de categorias
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$apiUrl/categorias'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categoriesJson = data['categorias'];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener categorias');
    }
  }

  // Metodo para crear una nueva categoria
  Future<void> createCategory(String nombre, String descripcion) async {
    final response = await http.post(
      Uri.parse('$apiUrl/categoria/store'),
      body: {'nombre': nombre, 'descripcion': descripcion},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al crear la categoria');
    }
  }

  // Metodo para editar una categoria existente
  Future<void> updateCategory(int id, String nombre, String descripcion) async {
    final response = await http.post(
      Uri.parse('$apiUrl/categoria/update'),
      body: {'id': '$id', 'nombre': nombre, 'descripcion': descripcion},
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la categoria');
    }
  }

  // Metodo para obtener una categoria por ID
  Future<Category> getCategoryById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/categoria/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Category.fromJson(data['categoria']);
    } else {
      throw Exception('Error al obtener la categoria');
    }
  }
}
