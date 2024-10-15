import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/meme.dart';

class MemeService {
  final String apiUrl = dotenv.env['API_URL']!;

  // Método para obtener la lista de memes
  Future<List<Meme>> getMemes() async {
    final response = await http.get(Uri.parse('$apiUrl/memes'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List memesJson = data[
          'categorias']; // La clave es 'categorias' según el JSON proporcionado
      return memesJson.map((json) => Meme.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener memes');
    }
  }

  // Método para crear un nuevo meme
  Future<void> createMeme(String nombre, String descripcion, int categoriaId,
      String imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/meme/store'),
    );

    // Agregamos los campos del formulario
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['categoria_id'] = categoriaId.toString();

    // Agregamos el archivo de imagen
    request.files.add(await http.MultipartFile.fromPath('imagen', imagePath));

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Error al crear el meme');
    }
  }

  // Método para actualizar un meme existente
  Future<void> updateMeme(int id, String nombre, String descripcion,
      int categoriaId, String? imagePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/meme/update'),
    );

    // Agregamos los campos del formulario
    request.fields['id'] = id.toString();
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['categoria_id'] = categoriaId.toString();

    // Si se proporciona una nueva imagen, la agregamos
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('imagen', imagePath));
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el meme');
    }
  }

  // Método para obtener un meme por su ID
  Future<Meme> getMemeById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/meme/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meme.fromJson(data['meme']);
    } else {
      throw Exception('Error al obtener el meme');
    }
  }
}
