import 'package:flutter/material.dart';
import 'interfaces/redacteur_interface.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Infos - Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E63),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const RedacteurInterface(),
    );
  }
}
