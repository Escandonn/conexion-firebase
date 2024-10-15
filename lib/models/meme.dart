class Meme {
  final int id;
  final int categoriaId;
  final String nombre;
  final String descripcion;
  final String url;
  final String categoria;

  Meme({
    required this.id,
    required this.categoriaId,
    required this.nombre,
    required this.descripcion,
    required this.url,
    required this.categoria,
  });

  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'],
      categoriaId: json['categoria_id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      url: json['url'],
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria_id': categoriaId,
      'nombre': nombre,
      'descripcion': descripcion,
      'url': url,
      'categoria': categoria,
    };
  }
}
