import 'package:flutter/material.dart';
import 'vista_promesas.dart';
import 'vista_objetivos.dart';
import 'vista_diario.dart'; // Import de la nueva vista

class VistaPrincipal extends StatefulWidget {
  const VistaPrincipal({super.key});

  @override
  State<VistaPrincipal> createState() => _VistaPrincipalState();
}

class _VistaPrincipalState extends State<VistaPrincipal> {
  int _indiceSeleccionado = 0;

  // Añadimos la vista del diario a la lista
  static const List<Widget> _vistas = <Widget>[
    VistaPromesas(),
    VistaObjetivos(),
    VistaDiario(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _indiceSeleccionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _vistas.elementAt(_indiceSeleccionado),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Añadimos el item del diario
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Promesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rtl_outlined),
            label: 'Objetivos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Diario',
          ),
        ],
        currentIndex: _indiceSeleccionado,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}