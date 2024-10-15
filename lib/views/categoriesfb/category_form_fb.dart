import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';


class CategoryFormFb extends StatefulWidget {
  final String? categoryId;

  const CategoryFormFb({super.key, this.categoryId});

  @override
  CategoryFormFbState createState() => CategoryFormFbState();
}

class CategoryFormFbState extends State<CategoryFormFb> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _descripcion = '';

  bool _isLoading = false;
  final CollectionReference categoriesRef =
      FirebaseFirestore.instance.collection('categorias');

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _loadCategory();
    }
  }

  Future<void> _loadCategory() async {
    setState(() {
      _isLoading = true;
    });
    final docSnapshot = await categoriesRef.doc(widget.categoryId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nombre = data['nombre'] ?? '';
        _descripcion = data['descripcion'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.categoryId == null) {
        // Crear nueva categoría
        categoriesRef.add({
          'nombre': _nombre,
          'descripcion': _descripcion,
        });
      } else {
        // Actualizar categoría existente
        categoriesRef.doc(widget.categoryId).update({
          'nombre': _nombre,
          'descripcion': _descripcion,
        });
      }
      context.go('/categories/fb');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.categoryId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Categoría' : 'Agregar Categoría'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _nombre,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _nombre = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: _descripcion,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      onSaved: (value) {
                        _descripcion = value ?? '';
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveCategory,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
