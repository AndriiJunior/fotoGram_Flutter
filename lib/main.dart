import 'package:flutter/material.dart';
import 'package:foto_gram/pages/home_page.dart';
import 'package:foto_gram/services/firebase_service.dart';
import './pages/login_page.dart';
import './pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FotoGram',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(196, 69, 100, 211),
        primarySwatch: Colors.indigo,
      ),
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'home': (context) => HomePage(),
      },
    );
  }
}
