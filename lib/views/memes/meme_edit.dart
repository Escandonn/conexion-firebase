import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memesv2/models/category.dart';
import 'package:memesv2/models/meme.dart';
import 'package:memesv2/services/category_service.dart';
import 'package:memesv2/services/meme_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class MemeEdit extends StatefulWidget {
  final String id;

  const MemeEdit({super.key, required this.id});

  @override
  State<MemeEdit> createState() => _MemeEditState();
}

class _MemeEditState extends State<MemeEdit> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final MemeService _memeService = MemeService();
  final CategoryService _categoryService = CategoryService();
  final String apiUrl = dotenv.env['API_URL_IMAGES']!;

  int? _selectedCategoryId;
  File? _imageFile;
  List<Category> _categories = [];
  late Future<Meme> _futureMeme;

  @override
  void initState() {
    super.initState();
    // Cargamos las categorías y los datos del meme al iniciar la vista
    _loadCategories();
    _futureMeme = _memeService.getMemeById(int.parse(widget.id));
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

  /// Método para manejar la acción de actualizar el meme.
  /// Valida el formulario y envía los datos actualizados al servicio.
  void _updateMeme() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _memeService.updateMeme(
          int.parse(widget.id),
          _nombreController.text,
          _descripcionController.text,
          _selectedCategoryId!,
          _imageFile?.path,
        );

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meme actualizado con éxito')),
        );

        // ignore: use_build_context_synchronously
        context.go('/memes');
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el meme: $e')),
        );
      }
    }
  }

  /// Método para seleccionar una nueva imagen desde la galería o la cámara.
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
        title: const Text('Editar Meme'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<Meme>(
        future: _futureMeme,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final meme = snapshot.data!;
            // Asignamos los valores actuales del meme a los controladores y variables
            _nombreController.text = meme.nombre;
            _descripcionController.text = meme.descripcion;
            _selectedCategoryId ??= meme.categoriaId;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              // Formulario para editar los datos del meme.
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
                    // Botón para seleccionar una nueva imagen.
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Cambiar Imagen'),
                    ),
                    const SizedBox(height: 16),
                    // Mostrar la imagen actual o la nueva imagen seleccionada.
                    if (_imageFile != null)
                      Image.file(
                        _imageFile!,
                        height: 200,
                      )
                    else
                      Image.network(
                        '$apiUrl/images/${meme.url}',
                        height: 200,
                      ),
                    const SizedBox(height: 20),
                    // Botón para enviar el formulario y actualizar el meme.
                    ElevatedButton(
                      onPressed: _updateMeme,
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el meme: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
