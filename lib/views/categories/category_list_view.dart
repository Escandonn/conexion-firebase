import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/category.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para cargar el rol del usuario

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<Category>> _futureCategories;
  String userRole = 'user'; // Rol por defecto

  @override
  void initState() {
    super.initState();
    _loadUserRole(); // Cargar el rol al iniciar
    _futureCategories = _categoryService.getCategories();
  }

  /// Método para cargar el rol del usuario desde SharedPreferences
  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('userRole') ??
          'user'; // Si no hay rol, asignamos 'user'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorías'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<List<Category>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  // Crea la lista de categorías
                  title: Text(category.nombre),
                  subtitle: Text(category.descripcion),
                  trailing: userRole ==
                          'admin' // Mostrar icono de edición solo si el rol es 'admin'
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            context.go('/edit/${category.id}');
                          },
                        )
                      : null, // No mostrar ícono si no es admin
                );
              },
            );
          } else if (snapshot.hasError) {
            // Valida errores al cargar categorías
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: userRole ==
              'admin' // Mostrar botón de agregar solo si el rol es admin
          ? FloatingActionButton(
              onPressed: () {
                context.go('/create');
              },
              child: const Icon(Icons.add),
            )
          : null, // Si no es admin, no mostramos el botón
    );
  }
}
