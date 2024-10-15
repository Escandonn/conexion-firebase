// lib/models/category.dart

class Categoryfb {
  final String? id; // Cambiado a String? para compatibilidad con Firebase
  final String nombre;
  final String descripcion;

  Categoryfb({this.id, required this.nombre, required this.descripcion});

  // Método para convertir JSON en una instancia de Category
  factory Categoryfb.fromJson(Map<String, dynamic> json, String id) {
    return Categoryfb(
      id: id,
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  // Método para convertir una instancia de Category en JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
