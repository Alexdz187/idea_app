import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/objetivo_provider.dart';

class VistaObjetivos extends StatelessWidget {
  const VistaObjetivos({super.key});

  void _mostrarDialogoNuevoObjetivo(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Objetivo'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Describe tu objetivo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  Provider.of<ObjetivoProvider>(context, listen: false)
                      .agregarObjetivo(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Objetivos'),
      ),
      body: Consumer<ObjetivoProvider>(
        builder: (context, provider, child) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.objetivos.isEmpty) {
            return const Center(child: Text('Aún no tienes objetivos. ¡Añade uno!'));
          }

          return ListView.builder(
            itemCount: provider.objetivos.length,
            itemBuilder: (context, index) {
              final objetivo = provider.objetivos[index];
              return Dismissible(
                key: Key(objetivo.id.toString()),
                background: Container(
                  color: Colors.red.shade400,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  provider.eliminarObjetivo(objetivo.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Objetivo "${objetivo.descripcion}" eliminado.')),
                  );
                },
                child: CheckboxListTile(
                  title: Text(
                    objetivo.descripcion,
                    style: TextStyle(
                      decoration: objetivo.completado
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  value: objetivo.completado,
                  onChanged: (bool? value) {
                    objetivo.completado = value ?? false;
                    provider.actualizarObjetivo(objetivo);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoObjetivo(context),
        tooltip: 'Nuevo Objetivo',
        child: const Icon(Icons.add),
      ),
    );
  }
}