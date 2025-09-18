import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'vista_promesas.dart';
import 'vista_objetivos.dart';
import 'vista_diario.dart';
import '../providers/promesa_provider.dart';
import '../providers/objetivo_provider.dart';
import '../providers/diario_provider.dart';

class VistaPrincipal extends StatefulWidget {
  const VistaPrincipal({super.key});

  @override
  State<VistaPrincipal> createState() => _VistaPrincipalState();
}

class _VistaPrincipalState extends State<VistaPrincipal> {
  final PageController _pageController = PageController();
  int _paginaActual = 0;

  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurarnos de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revisarRazonOnboarding();
    });
  }

  // NUEVA FUNCIÓN para mostrar la guía
  Future<void> _revisarRazonOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final razonOtro = prefs.getString('onboarding_razon_otro');

    if (razonOtro != null && razonOtro.isNotEmpty) {
      // La razón existe, mostramos la guía
      _mostrarGuiaCrearPromesa(context, razonOtro);
      // Limpiamos la preferencia para que no se muestre de nuevo
      await prefs.remove('onboarding_razon_otro');
    }
  }

  void _mostrarGuiaCrearPromesa(BuildContext context, String razon) {
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100, // Posición aproximada sobre el FloatingActionButton
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              overlayEntry?.remove();
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_downward, color: Colors.white, size: 30),
                  const SizedBox(height: 10),
                  const Text(
                    '¡Genial! Un buen primer paso es crear una promesa basada en lo que escribiste.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"$razon"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Toca aquí para cerrar y luego en el botón "+" para empezar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Insertamos el overlay en la pantalla
    Overlay.of(context).insert(overlayEntry);
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _paginaActual = page;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PromesaProvider()),
        ChangeNotifierProvider(create: (context) => ObjetivoProvider()),
        ChangeNotifierProvider(create: (context) => DiarioProvider()),
      ],
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: const <Widget>[
            VistaPromesas(),
            VistaObjetivos(),
            VistaDiario(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _paginaActual,
          onTap: _onBottomNavTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Promesas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Objetivos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Diario',
            ),
          ],
        ),
      ),
    );
  }
}