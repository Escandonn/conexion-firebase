import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:memesv2/models/meme.dart';
import 'package:memesv2/services/meme_service.dart';
import 'package:memesv2/widgets/navigation_drawer_menu.dart';

class MemeList extends StatefulWidget {
  const MemeList({super.key});

  @override
  State<MemeList> createState() => _MemeListState();
}

class _MemeListState extends State<MemeList> {
  final MemeService _memeService = MemeService();
  late Future<List<Meme>> _futureMemes;
  String apiUrl = '';
  @override
  void initState() {
    super.initState();
    // Inicializa la futura lista de memes al cargar la vista
    _futureMemes = _memeService.getMemes();
    apiUrl = dotenv.env['API_URL_IMAGES']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Memes'),
      ),
      drawer: const NavigationDrawerMenu(),
      body: FutureBuilder<List<Meme>>(
        future: _futureMemes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final memes = snapshot.data!;
            return ListView.builder(
              itemCount: memes.length,
              itemBuilder: (context, index) {
                final meme = memes[index];
                return ListTile(
                  leading: Image.network(
                    '$apiUrl/images/${meme.url}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(meme.nombre),
                  subtitle: Text(meme.descripcion),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navega a la vista de edición con el ID del meme
                      context.go('/memes/edit/${meme.id}');
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          // Muestra un indicador de carga mientras se obtienen los datos
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega a la vista de creación de memes
          context.go('/memes/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
