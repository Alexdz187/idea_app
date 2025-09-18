import 'package:flutter/material.dart';
import '../modelos/entrada_diario.dart';
import '../servicios/db_servicio.dart';

class DiarioProvider extends ChangeNotifier {
  List<EntradaDiario> _entradas = [];
  bool _cargando = false;

  List<EntradaDiario> get entradas => _entradas;
  bool get cargando => _cargando;

  DiarioProvider() {
    cargarEntradas();
  }

  Future<void> cargarEntradas() async {
    _cargando = true;
    notifyListeners();
    _entradas = await DBServicio.instancia.leerTodasLasEntradas();
    _cargando = false;
    notifyListeners();
  }

  Future<void> agregarOActualizarEntrada(int? id, String contenido) async {
    if (id == null) {
      // Crear nueva entrada
      final nuevaEntrada = EntradaDiario(contenido: contenido, fecha: DateTime.now());
      await DBServicio.instancia.crearEntradaDiario(nuevaEntrada);
    } else {
      // Actualizar entrada existente
      final entradaExistente = await DBServicio.instancia.leerEntradaDiario(id);
      if (entradaExistente != null) {
        entradaExistente.contenido = contenido;
        await DBServicio.instancia.actualizarEntradaDiario(entradaExistente);
      }
    }
    await cargarEntradas();
  }

  Future<void> eliminarEntrada(int id) async {
    await DBServicio.instancia.eliminarEntradaDiario(id);
    await cargarEntradas();
  }
}