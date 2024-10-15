import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerMenu extends StatelessWidget {
  const NavigationDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menú de Navegación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category, color: Colors.black),
            title: const Text(
              'Categorías',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.mood, color: Colors.black),
            title: const Text(
              'Memes',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/memes');
              Navigator.of(context).pop();
            },
            
          ),
           ListTile(
            leading: const Icon(Icons.mood, color: Colors.black),
            title: const Text(
              'Categorias FB',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/categories/fb');
              Navigator.of(context).pop();
            },
            
          ),
             ListTile(
            leading: const Icon(Icons.mood, color: Colors.black),
            title: const Text(
              'add Categoria FB',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              context.go('/categories/create');
              Navigator.of(context).pop();
            },
            
          ),
         
        ],
      ),
    );
  }
}
