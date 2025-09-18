import 'package:flutter/material.dart';

class TemaApp {
  // --- Colores Base ---
  static const Color azulClaro = Color(0xFFADD8E6);   // Calma, confianza
  static const Color verdeSuave = Color(0xFF90EE90);  // Crecimiento, esperanza
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color grisClaro = Color(0xFFF5F5F5);   // Limpieza visual

  // --- Colores de Énfasis ---
  static const Color dorado = Color(0xFFFFD700);      // Motivación, "luz"
  static const Color violetaClaro = Color(0xFFE6E6FA); // Espiritualidad

  // --- Colores de Texto ---
  static const Color textoPrincipal = Color(0xFF333333);
  static const Color textoSecundario = Color(0xFF666666);

  static final ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de colores principal
    colorScheme: ColorScheme.fromSeed(
      seedColor: azulClaro,
      primary: azulClaro,
      secondary: verdeSuave,
      background: grisClaro,
      surface: blanco,
      onPrimary: textoPrincipal,
      onSecondary: textoPrincipal,
      onBackground: textoPrincipal,
      onSurface: textoPrincipal,
      error: Colors.redAccent,
    ),

    // Tema de la AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: azulClaro,
      foregroundColor: textoPrincipal,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textoPrincipal,
      ),
    ),
    
    // Tema del FloatingActionButton
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: dorado,
      foregroundColor: textoPrincipal,
    ),

    // Tema de los textos
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: textoPrincipal, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textoPrincipal, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textoPrincipal, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textoPrincipal, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: textoSecundario, fontSize: 16),
      bodyMedium: TextStyle(color: textoSecundario, fontSize: 14),
    ),

    // Tema de los botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: verdeSuave,
        foregroundColor: textoPrincipal,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}