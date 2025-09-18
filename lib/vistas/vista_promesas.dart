import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/promesa_provider.dart';
import 'vista_crear_promesa.dart';
import '../modelos/promesa.dart';
import 'package:intl/intl.dart';
import '../temas/tema_app.dart';
import 'vista_detalle_promesa.dart';
import 'vista_papelera.dart';
import 'vista_estadisticas.dart';
import 'vista_configuracion.dart';

class VistaPromesas extends StatelessWidget {
  const VistaPromesas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Promesas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Estadísticas',
            // ONPRESSED CORREGIDO
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VistaEstadisticas()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Papelera',
            // ONPRESSED CORREGIDO
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VistaPapelera()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configuración',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const VistaConfiguracion()),
              );
            },
          ),
        ],
      ),
      body: Consumer<PromesaProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.promesas.isEmpty) {
            return _buildVistaVacia(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: provider.promesas.length,
            itemBuilder: (context, index) {
              final promesa = provider.promesas[index];
              return _buildTarjetaPromesa(context, promesa);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VistaCrearPromesa()),
          );
        },
        tooltip: 'Nueva Promesa',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTarjetaPromesa(BuildContext context, Promesa promesa) {
    final diasRestantes = promesa.fechaFinalizacion?.difference(DateTime.now()).inDays;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: promesa.completada
            ? Icon(Icons.check_circle, color: TemaApp.verdeSuave)
            : promesa.esPromesaADios
                ? Icon(Icons.shield, color: TemaApp.dorado)
                : const Icon(Icons.check_circle_outline, color: Colors.grey),
        title: Text(promesa.descripcion,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  decoration: promesa.completada ? TextDecoration.lineThrough : TextDecoration.none,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Iniciada: ${DateFormat.yMMMd('es_ES').format(promesa.fechaCreacion)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (diasRestantes != null && diasRestantes >= 0 && !promesa.completada)
                Text(
                  'Quedan: ${diasRestantes + 1} días',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TemaApp.dorado.withAlpha(230), // Corrección de deprecated
                      ),
                ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VistaDetallePromesa(promesa: promesa),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVistaVacia(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.lightbulb_outline, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'Aún no tienes promesas.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Toca el botón "+" para crear tu primera promesa y empezar tu camino.',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}