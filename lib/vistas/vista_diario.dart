import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diario_provider.dart';
import 'vista_crear_entrada_diario.dart';

class VistaDiario extends StatelessWidget {
  const VistaDiario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Diario'),
      ),
      body: Consumer<DiarioProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.entradas.isEmpty) {
            return const Center(child: Text('Aún no has escrito nada. ¡Anímate!'));
          }

          return ListView.builder(
            itemCount: provider.entradas.length,
            itemBuilder: (context, index) {
              final entrada = provider.entradas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    '${DateFormat.yMMMd('es_ES').format(entrada.fecha)} - ${DateFormat.Hm('es_ES').format(entrada.fecha)}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    entrada.contenido,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VistaCrearEntradaDiario(entrada: entrada),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const VistaCrearEntradaDiario()),
          );
        },
        tooltip: 'Nueva Entrada',
        child: const Icon(Icons.edit),
      ),
    );
  }
}