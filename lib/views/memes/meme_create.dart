import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memesv2/models/category.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/services/meme_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class MemeCreate extends StatefulWidget {
  const MemeCreate({super.key});

  @override
  State<MemeCreate> createState() => _MemeCreateState();
}

class _MemeCreateState extends State<MemeCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final MemeService _memeService = MemeService();
  final CategoryService _categoryService = CategoryService();

  int? _selectedCategoryId;
  File? _imageFile;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    // Cargamos la lista de categorías al iniciar la vista
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      // Manejar errores si es necesario
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  /// Método para manejar la acción de crear un nuevo meme.
  /// Valida el formulario y envía los datos al servicio.
  void _createMeme() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      try {
        await _memeService.createMeme(
          _nombreController.text,
          _descripcionController.text,
          _selectedCategoryId!,
          _imageFile!.path,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meme creado con éxito')),
        );

        // ignore: use_build_context_synchronously
        context.go('/memes');
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el meme: $e')),
        );
      }
    } else if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen')),
      );
    }
  }

  /// Método para seleccionar una imagen desde la galería o la cámara.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource
          .gallery, // Cambia a ImageSource.camera si deseas tomar una foto
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  /// Método para construir el Dropdown de categorías con filtro de búsqueda.
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Categoría',
      ),
      value: _selectedCategoryId,
      items: _categories.map((Category category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.nombre),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _selectedCategoryId = newValue;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Por favor, selecciona una categoría';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Meme'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // Formulario para ingresar los datos del nuevo meme.
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de texto para el nombre del meme.
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
              // Campo de texto para la descripción del meme.
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
              const SizedBox(height: 16),
              // Dropdown para seleccionar la categoría.
              _buildCategoryDropdown(),
              const SizedBox(height: 16),
              // Botón para seleccionar una imagen.
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Seleccionar Imagen'),
              ),
              const SizedBox(height: 16),
              // Mostrar la imagen seleccionada.
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                ),
              const SizedBox(height: 20),
              // Botón para enviar el formulario y crear el meme.
              ElevatedButton(
                onPressed: _createMeme,
                child: const Text('Crear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
