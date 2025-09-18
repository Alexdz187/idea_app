import 'package:flutter/material.dart';
import 'vista_cuestionario.dart';

class VistaBienvenida extends StatelessWidget {
  const VistaBienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_border, size: 100, color: Colors.pinkAccent),
              const SizedBox(height: 20),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Haz tu promesa hoy, y empieza hoy.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const VistaCuestionario()),
                  );
                },
                child: const Text('Comenzar Viaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}