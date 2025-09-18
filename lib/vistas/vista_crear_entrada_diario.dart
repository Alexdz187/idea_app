import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/entrada_diario.dart';
import '../providers/diario_provider.dart';

class VistaCrearEntradaDiario extends StatefulWidget {
  final EntradaDiario? entrada;

  const VistaCrearEntradaDiario({super.key, this.entrada});

  @override
  State<VistaCrearEntradaDiario> createState() => _VistaCrearEntradaDiarioState();
}

class _VistaCrearEntradaDiarioState extends State<VistaCrearEntradaDiario> {
  late final TextEditingController _controller;
  bool get _esModoEdicion => widget.entrada != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entrada?.contenido);
  }

  void _guardarEntrada() {
    if (_controller.text.isNotEmpty) {
      Provider.of<DiarioProvider>(context, listen: false)
          .agregarOActualizarEntrada(widget.entrada?.id, _controller.text);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No puedes guardar una entrada vacía.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esModoEdicion ? 'Editar Entrada' : 'Nueva Entrada'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarEntrada,
            tooltip: 'Guardar',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          expands: true,
          maxLines: null,
          minLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '¿Cómo te sientes hoy? ¿Qué ha pasado?',
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}