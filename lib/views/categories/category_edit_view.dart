// lib/views/categories/category_edit.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/category.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';
// Importamos el Drawer

/// Vista para editar una categoría existente.
/// Permite al usuario modificar el nombre y la descripción de la categoría seleccionada.
class CategoryEdit extends StatefulWidget {
  final String id; // ID de la categoría a editar.

  const CategoryEdit({super.key, required this.id});

  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  late Future<Category>
      _futureCategory; // Futuro que contendrá la categoría a editar.

  @override
  void initState() {
    super.initState();
    // Al iniciar, obtenemos los datos de la categoría por su ID.
    _futureCategory = _categoryService.getCategoryById(int.parse(widget.id));
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de actualizar la categoría.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al método del servicio para actualizar la categoría.
        await _categoryService.updateCategory(
          int.parse(widget.id),
          _nombreController.text,
          _descripcionController.text,
        );

        // Mostramos un mensaje de éxito.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría actualizada con éxito')),
        );

        // Navegamos de regreso a la lista de categorías.
        // ignore: use_build_context_synchronously
        context.go('/');
      } catch (e) {
        // En caso de error, mostramos un mensaje al usuario.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la categoría: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: FutureBuilder<Category>(
        future: _futureCategory,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final category = snapshot.data!;
            // Asignamos los valores actuales de la categoría a los controladores.
            _nombreController.text = category.nombre;
            _descripcionController.text = category.descripcion;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos de la categoría.
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo de texto para el nombre de la categoría.
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Campo de texto para la descripción de la categoría.
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar la categoría.
                    ElevatedButton(
                      onPressed: _updateCategory,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // En caso de error al obtener los datos, mostramos un mensaje.
            return Center(
              child: Text('Error al cargar la categoría: ${snapshot.error}'),
            );
          }
          // Mientras se cargan los datos, mostramos un indicador de progreso.
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
