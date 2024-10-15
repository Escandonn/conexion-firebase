class Category {
  final int id;
  final String nombre;
  final String descripcion;

  Category({required this.id, required this.nombre, required this.descripcion});

  // Metodo para convertir JSON en una instancia de Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }

  // MEtodo para convertir una instancia de Category en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}
