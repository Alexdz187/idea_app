import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../vista_principal.dart';

class VistaApoyo extends StatelessWidget {
  const VistaApoyo({super.key});

  // Esta es la función que soluciona el problema de navegación
  Future<void> _finalizarOnboarding(BuildContext context) async {
    // 1. Guardamos la preferencia para que no vuelva a ver el onboarding.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haVistoOnboarding', true);

    // 2. Navegamos a la pantalla principal y eliminamos todas las rutas anteriores.
    // Esto evita que el botón de "atrás" aparezca.
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const VistaPrincipal()),
        (Route<dynamic> route) => false, // Este predicado elimina todo lo anterior.
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.support_agent,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 30),
              const Text(
                'Estamos aquí para ayudarte',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Esta aplicación es una herramienta en tu camino. Úsala para mantenerte firme, reflexionar y celebrar tus logros.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                // Al pulsar el botón, llamamos a la nueva función de navegación
                onPressed: () => _finalizarOnboarding(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Empezar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}