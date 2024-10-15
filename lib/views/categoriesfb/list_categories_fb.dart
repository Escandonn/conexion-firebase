import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/categoryfb.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class ListCategoriesFb extends StatelessWidget {
  const ListCategoriesFb({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference categoriesRef =
        FirebaseFirestore.instance.collection('categorias');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go('/categories/add');
            },
          ),
        ],
      ),
      drawer: const NavigationDrawerMenu(),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!.docs.map((doc) {
              return Categoryfb.fromJson(doc.data() as Map<String, dynamic>, doc.id);
            }).toList();

            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.nombre),
                  subtitle: Text(category.descripcion),
                  onTap: () {
                    context.go('/categories/edit/fb/${category.id}');
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Mostrar diálogo de confirmación antes de eliminar
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmación'),
                          content: const Text('¿Desea eliminar el registro?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Cerrar el diálogo sin hacer nada
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Eliminar la categoría y cerrar el diálogo
                                categoriesRef.doc(category.id).delete();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Sí'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar categorías'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
