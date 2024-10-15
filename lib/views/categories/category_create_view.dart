// lib/views/categories/category_create.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

/// Vista para crear una nueva categoría.
class CategoryCreate extends StatefulWidget {
  const CategoryCreate({super.key});

  @override
  State<CategoryCreate> createState() => _CategoryCreateState();
}

class _CategoryCreateState extends State<CategoryCreate> {
  // Clave global para el formulario, nos permite validar el formulario más adelante.
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto.
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  // Instancia del servicio de categoria
  final CategoryService _categoryService = CategoryService();

  @override
  void dispose() {
    // se liberan los controladores cuando ya no son necesarios.
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Metodo para manejar la accion de crear una nueva categoria.
  // Valida el formulario y envia los datos al servicio.
  void _createCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Llamamos al metodo del servicio para crear la categoriya.
        await _categoryService.createCategory(
          _nombreController.text,
          _descripcionController.text,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoría creada con éxito')),
        );

        // luego de crear el registro, navega a la lista de categorías.
        // ignore: use_build_context_synchronously
        context.go('/');
      } catch (e) {
        // En caso de error, mostramos un mensaje al usuario.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la categoría: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Categoría'),
      ),
      drawer: const NavigationDrawerMenu(), // Usamos el widget personalizado
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos de la nueva categoría.
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
              // Botón para enviar el formulario y crear la categoría.
              ElevatedButton(
                onPressed: _createCategory,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
