import 'package:flutter/material.dart';
import '../modelos/objetivo.dart';
import '../servicios/db_servicio.dart';

class ObjetivoProvider extends ChangeNotifier {
  List<Objetivo> _objetivos = [];
  bool _cargando = false;

  List<Objetivo> get objetivos => _objetivos;
  bool get cargando => _cargando;

  ObjetivoProvider() {
    cargarObjetivos();
  }

  Future<void> cargarObjetivos() async {
    _cargando = true;
    notifyListeners();
    _objetivos = await DBServicio.instancia.leerTodosLosObjetivos();
    _cargando = false;
    notifyListeners();
  }

  Future<void> agregarObjetivo(String descripcion) async {
    final nuevoObjetivo = Objetivo(descripcion: descripcion);
    await DBServicio.instancia.crearObjetivo(nuevoObjetivo);
    await cargarObjetivos();
  }

  Future<void> actualizarObjetivo(Objetivo objetivo) async {
    await DBServicio.instancia.actualizarObjetivo(objetivo);
    await cargarObjetivos();
  }

  Future<void> eliminarObjetivo(int id) async {
    await DBServicio.instancia.eliminarObjetivo(id);
    await cargarObjetivos();
  }
}