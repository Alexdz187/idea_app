import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../modelos/promesa.dart';
import '../providers/promesa_provider.dart';
import 'vista_crear_promesa.dart';
import '../temas/tema_app.dart'; // <-- IMPORT AÑADIDO Y CORREGIDO

class VistaDetallePromesa extends StatelessWidget {
  final Promesa promesa;

  const VistaDetallePromesa({super.key, required this.promesa});

  void _editarPromesa(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VistaCrearPromesa(promesa: promesa),
      ),
    );
  }

  void _compartirPromesa() {
    final textoCompartir = '''
¡Hola! 👋 Te comparto una promesa que me he hecho para mejorar.

Mi promesa es:
"${promesa.descripcion}"

¡Deséame suerte! Puedes hacer tus propias promesas descargando la app.
''';
    Share.share(textoCompartir, subject: 'Mi promesa de superación');
  }

  void _eliminarPromesa(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final razonController = TextEditingController();
        return AlertDialog(
          title: const Text('¿Por qué eliminas esta promesa?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('La promesa se moverá a la papelera. Podrás restaurarla durante 7 días.'),
              const SizedBox(height: 15),
              TextField(
                controller: razonController,
                decoration: const InputDecoration(
                  labelText: 'Razón (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade400),
              onPressed: () {
                Provider.of<PromesaProvider>(context, listen: false).moverAPapelera(
                  promesa.id!,
                  razon: razonController.text.isNotEmpty ? razonController.text : null,
                );
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Promesa movida a la papelera.')),
                );
              },
              child: const Text('Mover a Papelera'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PromesaProvider>(
      builder: (context, provider, child) {
        final promesaActual = provider.promesas.firstWhere((p) => p.id == promesa.id, orElse: () => promesa);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalle de la Promesa'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _eliminarPromesa(context),
                tooltip: 'Eliminar Promesa',
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: _compartirPromesa,
                tooltip: 'Compartir Promesa',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    promesaActual.descripcion,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  value: promesaActual.completada,
                  onChanged: (bool valor) {
                    provider.marcarComoCompletada(promesaActual.id!, valor);
                  },
                  title: const Text('Marcar como completada'),
                  secondary: Icon(
                    promesaActual.completada ? Icons.check_circle : Icons.check_circle_outline,
                    color: promesaActual.completada ? TemaApp.verdeSuave : Colors.grey,
                  ),
                ),
                const Divider(height: 32),
                _buildInfoRow(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: 'Fecha de inicio',
                  value: DateFormat.yMMMd('es_ES').format(promesaActual.fechaCreacion),
                ),
                if (promesaActual.fechaFinalizacion != null) ...[
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    context,
                    icon: Icons.flag_outlined,
                    label: 'Fecha de finalización',
                    value: DateFormat.yMMMd('es_ES').format(promesaActual.fechaFinalizacion!),
                  ),
                ],
                const Spacer(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () => _editarPromesa(context),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar Promesa'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
        const SizedBox(width: 12),
        Text('$label:', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: 8),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}