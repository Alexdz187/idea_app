import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/promesa_provider.dart';
import '../modelos/promesa.dart';

class VistaPapelera extends StatelessWidget {
  const VistaPapelera({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papelera'),
      ),
      body: Consumer<PromesaProvider>(
        builder: (context, provider, child) {
          if (provider.promesasEliminadas.isEmpty) {
            return const Center(
              child: Text(
                'La papelera está vacía.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.promesasEliminadas.length,
            itemBuilder: (context, index) {
              final promesa = provider.promesasEliminadas[index];
              return _buildTarjetaPromesaEliminada(context, promesa);
            },
          );
        },
      ),
    );
  }

  Widget _buildTarjetaPromesaEliminada(BuildContext context, Promesa promesa) {
    final provider = Provider.of<PromesaProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              promesa.descripcion,
              style: const TextStyle(decoration: TextDecoration.lineThrough),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Eliminada: ${DateFormat.yMMMd('es_ES').format(promesa.fechaEliminacion!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.restore_from_trash, size: 20),
                  label: const Text('Restaurar'),
                  onPressed: () => provider.restaurarPromesa(promesa.id!),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete_forever, size: 20),
                  label: const Text('Borrar'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () => provider.eliminarPermanentemente(promesa.id!),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}