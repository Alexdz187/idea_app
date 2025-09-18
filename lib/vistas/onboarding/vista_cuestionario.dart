import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vista_apoyo.dart';

class VistaCuestionario extends StatefulWidget {
  const VistaCuestionario({super.key});

  @override
  State<VistaCuestionario> createState() => _VistaCuestionarioState();
}

class _VistaCuestionarioState extends State<VistaCuestionario> {
  // Lista de nuevas opciones
  final List<String> _opciones = [
    'Quiero ser más disciplinado.',
    'Tengo una meta personal importante.',
    'Necesito un cambio en mi vida.',
    'Suelo procrastinar mucho.',
    'Me falta motivación para actuar.',
    'Lidio con sentimientos de tristeza.',
    'Quiero dejar un mal hábito.',
    'Siento que he perdido el rumbo.',
    'Estoy pasando por un duelo o pérdida.',
  ];

  // Usamos un Set para guardar los índices de las opciones seleccionadas
  final Set<int> _indicesSeleccionados = {};
  bool _otroSeleccionado = false;
  final TextEditingController _otroController = TextEditingController();

  void _onOpcionSeleccionada(bool? seleccionado, int index) {
    setState(() {
      if (seleccionado == true) {
        _indicesSeleccionados.add(index);
      } else {
        _indicesSeleccionados.remove(index);
      }
    });
  }

  void _onOtroSeleccionado(bool? seleccionado) {
    setState(() {
      _otroSeleccionado = seleccionado ?? false;
      if (!_otroSeleccionado) {
        _otroController.clear();
      }
    });
  }

  // Guardar la razón "Otro" y navegar
  Future<void> _continuar() async {
    if (_otroSeleccionado && _otroController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      // Guardamos la razón personalizada para usarla después
      await prefs.setString('onboarding_razon_otro', _otroController.text);
    }
    
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const VistaApoyo()),
      );
    }
  }

  @override
  void dispose() {
    _otroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El botón se activa si hay al menos una opción marcada o si "Otro" está marcado
    final bool puedeContinuar = _indicesSeleccionados.isNotEmpty || _otroSeleccionado;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Un paso a la vez'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¿Qué es lo más cercano a lo que te está pasando?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Puedes seleccionar varias opciones.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Generamos la lista de Checkboxes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _opciones.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_opciones[index]),
                  value: _indicesSeleccionados.contains(index),
                  onChanged: (seleccionado) => _onOpcionSeleccionada(seleccionado, index),
                );
              },
            ),
            // Checkbox para la opción "Otro"
            CheckboxListTile(
              title: const Text('Otro...'),
              value: _otroSeleccionado,
              onChanged: _onOtroSeleccionado,
            ),
            // Campo de texto que aparece si "Otro" está seleccionado
            if (_otroSeleccionado)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: _otroController,
                  decoration: const InputDecoration(
                    hintText: 'Describe tu situación...',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
              ),
            const SizedBox(height: 80), // Espacio para el botón flotante
          ],
        ),
      ),
      floatingActionButton: puedeContinuar
          ? FloatingActionButton.extended(
              onPressed: _continuar,
              label: const Text('Continuar'),
              icon: const Icon(Icons.arrow_forward_ios),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}