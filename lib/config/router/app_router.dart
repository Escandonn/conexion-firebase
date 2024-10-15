import 'package:go_router/go_router.dart';
import 'package:memesv2/views/categories/category_create_view.dart';
import 'package:memesv2/views/categories/category_edit_view.dart';
import 'package:memesv2/views/categories/category_list_view.dart';
import 'package:memesv2/views/categoriesfb/category_form_fb.dart';
import 'package:memesv2/views/categoriesfb/list_categories_fb.dart';
import 'package:memesv2/views/memes/meme_create.dart';
import 'package:memesv2/views/memes/meme_edit.dart';
import 'package:memesv2/views/memes/meme_list.dart';

final router = GoRouter(
  routes: [
    // Ruta para listar categorías
    GoRoute(
      path: '/',
      builder: (context, state) => const CategoryList(),
    ),
    // Ruta para crear una nueva categoría
    GoRoute(
      path: '/create',
      builder: (context, state) => const CategoryCreate(),
    ),
    // Ruta para editar una categoría existente
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final id = state.params['id']!;
        return CategoryEdit(id: id);
      },
    ),
    // Ruta para listar memes
    GoRoute(
      path: '/memes',
      builder: (context, state) => const MemeList(),
    ),
    // Ruta para crear un nuevo meme
    GoRoute(
      path: '/memes/create',
      builder: (context, state) => const MemeCreate(),
    ),
    // Ruta para editar un meme existente
    GoRoute(
      path: '/memes/edit/:id',
      builder: (context, state) {
        final id = state.params['id']!;
        return MemeEdit(id: id);
      },
    ),
    // Ruta para listar categoria en FB
    GoRoute(
      path: '/categories/fb',
      builder: (context, state) => const ListCategoriesFb(),
    ),
    // Ruta para crear categoria en FB
     GoRoute(
      path: '/categories/create',
      builder: (context, state) => const CategoryFormFb(),
    ),
    // Ruta para editar categoria en FB
    GoRoute(
      path: '/categories/edit/fb/:id',
      builder: (context, state) {
        final id = state.params['id']!;
        return CategoryFormFb(categoryId:id);
      },
    ),
  ],
);
