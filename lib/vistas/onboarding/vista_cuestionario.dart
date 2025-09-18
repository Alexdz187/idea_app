import 'package:flutter/material.dart';
import 'vista_apoyo.dart';

class VistaCuestionario extends StatefulWidget {
  const VistaCuestionario({super.key});

  @override
  State<VistaCuestionario> createState() => _VistaCuestionarioState();
}

class _VistaCuestionarioState extends State<VistaCuestionario> {
  String? _opcionSeleccionada;

  final List<String> opciones = [
    'Suelo procrastinar mucho',
    'Me falta motivación para actuar',
    'Lidio con sentimientos de tristeza',
    'Quiero dejar un mal hábito',
    'Siento que he perdido el rumbo',
    'Estoy pasando por un duelo o pérdida',
    'Ninguna de las anteriores',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Un paso a la vez'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Qué es lo más cercano a lo que te está pasando?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Esto nos ayuda a entenderte mejor. No se comparte con nadie.'),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: opciones.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(opciones[index]),
                    value: opciones[index],
                    groupValue: _opcionSeleccionada,
                    onChanged: (value) {
                      setState(() {
                        _opcionSeleccionada = value;
                      });
                    },
                  );
                },
              ),
            ),
            if (_opcionSeleccionada != null)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const VistaApoyo()),
                    );
                  },
                  child: const Text('Continuar'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}