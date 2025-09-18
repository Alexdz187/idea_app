import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import ahora sí utilizado
import '../providers/promesa_provider.dart';
import '../modelos/promesa.dart';

class VistaCrearPromesa extends StatefulWidget {
  final Promesa? promesa;

  const VistaCrearPromesa({super.key, this.promesa});

  @override
  State<VistaCrearPromesa> createState() => _VistaCrearPromesaState();
}

class _VistaCrearPromesaState extends State<VistaCrearPromesa> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descripcionController;
  DateTime? _fechaFinalizacion;
  bool _esModoEdicion = false;
  bool _esPromesaADios = false;

  @override
  void initState() {
    super.initState();
    _descripcionController = TextEditingController();

    if (widget.promesa != null) {
      _esModoEdicion = true;
      _descripcionController.text = widget.promesa!.descripcion;
      _fechaFinalizacion = widget.promesa!.fechaFinalizacion;
      _esPromesaADios = widget.promesa!.esPromesaADios;
    }
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  // Esta función ahora sí es referenciada
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaFinalizacion ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaFinalizacion = fechaSeleccionada;
      });
    }
  }

  void _guardarPromesa() {
    if (_formKey.currentState!.validate()) {
      if (_esPromesaADios && !_esModoEdicion) {
        _mostrarDialogoAdvertencia();
      } else {
        _procederAGuardar();
      }
    }
  }

  void _mostrarDialogoAdvertencia() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Una Promesa Sagrada'),
        content: const Text(
            'Las cosas que le prometes a Dios, debes cumplirlas. A veces, solemos fallarnos a nosotros mismos, pero, ¿a nuestro Dios?\n\nEsta es una promesa con Él, así que lo que escribas aquí debes de cumplirlo al 100%.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _procederAGuardar();
            },
            child: const Text('Aceptar y Prometer'),
          )
        ],
      ),
    );
  }

  void _procederAGuardar() {
    final provider = Provider.of<PromesaProvider>(context, listen: false);
    
    if (_esModoEdicion) {
      final promesaActualizada = Promesa(
        id: widget.promesa!.id,
        descripcion: _descripcionController.text,
        fechaCreacion: widget.promesa!.fechaCreacion,
        fechaFinalizacion: _fechaFinalizacion,
        completada: widget.promesa!.completada,
        esPromesaADios: _esPromesaADios,
      );
      provider.actualizarPromesa(promesaActualizada);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      provider.agregarPromesa(
        _descripcionController.text,
        _fechaFinalizacion,
        esPromesaADios: _esPromesaADios,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esModoEdicion ? 'Editar Promesa' : 'Nueva Promesa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _guardarPromesa,
            tooltip: 'Guardar Cambios',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción de tu promesa',
                  hintText: 'Ej: Dedicar 30 minutos al día para leer.',
                  border: const OutlineInputBorder(),
                  helperText: _esModoEdicion && _esPromesaADios
                    ? 'Recuerda, esta es una promesa especial. Procura que los cambios mantengan el espíritu original.'
                    : null,
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Por favor, describe tu promesa.' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              // --- SECCIÓN DEL SELECTOR DE FECHA RESTAURADA ---
              const Text('¿Por cuánto tiempo? (Opcional)'),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  _fechaFinalizacion == null
                      ? 'Seleccionar fecha de finalización'
                      : 'Hasta el ${DateFormat.yMMMd('es_ES').format(_fechaFinalizacion!)}',
                ),
                trailing: _fechaFinalizacion != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _fechaFinalizacion = null),
                      )
                    : null,
                onTap: () => _seleccionarFecha(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              // --- FIN DE LA SECCIÓN RESTAURADA ---
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Es una promesa a Dios'),
                subtitle: const Text('Márcala para darle un significado especial'),
                value: _esPromesaADios,
                onChanged: (value) {
                  setState(() {
                    _esPromesaADios = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _guardarPromesa,
                child: Text(_esModoEdicion ? 'Guardar Cambios' : 'Crear Promesa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}