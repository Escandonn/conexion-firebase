import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memesv2/firebase_options.dart';
import 'config/router/app_router.dart'; // Asegúrate de importar bien tu archivo del router
import 'config/router/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Proporciona las opciones
  );

  // Carga las variables de entorno
  await dotenv.load(fileName: ".env");

  // Verifica el estado de login
  bool isLoggedIn = await checkLoginStatus();

  // Inicializa la app con el valor de `isLoggedIn`
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  // isLoggedIn es una variable que almacena el estado de autenticacion del usuario.
  // Indica si el usuario ha iniciado sesión o no.
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // Aquí estamos pasando `isLoggedIn` al router
    return MaterialApp.router(
      title: 'CRUD de Categorías',
      theme: AppTheme.lightTheme, // Aplicamos el tema claro
      darkTheme: AppTheme.darkTheme, // Aplicamos el tema oscuro (opcional)
      themeMode: ThemeMode.system, // El tema se adapta al modo del sistema
      routerConfig: AppRouter.router(isLoggedIn),
    );
  }
}

// Esta funcion verifica si el usuario ya ha iniciado sesion
// revisando si hay un token almacenado en SharedPreferences.

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return token != null;
}
