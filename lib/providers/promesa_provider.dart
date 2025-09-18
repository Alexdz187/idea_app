import 'package:flutter/material.dart';
import '../modelos/promesa.dart';
import '../servicios/db_servicio.dart';

class PromesaProvider extends ChangeNotifier {
  List<Promesa> _promesas = [];
  List<Promesa> _promesasEliminadas = [];
  bool _cargando = false;

  List<Promesa> get promesas => _promesas;
  List<Promesa> get promesasEliminadas => _promesasEliminadas;
  bool get cargando => _cargando;

  // --- Getters para Estadísticas ---
  int get totalPromesas => _promesas.length;
  int get promesasCompletadas => _promesas.where((p) => p.completada).length;

  PromesaProvider() {
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    _cargando = true;
    notifyListeners();
    
    _promesas = await DBServicio.instancia.leerTodasLasPromesas();
    _promesasEliminadas = await DBServicio.instancia.leerPromesasEliminadas();
    
    _cargando = false;
    notifyListeners();
  }

    Future<void> agregarPromesa(String descripcion, DateTime? fechaFinalizacion, {bool esPromesaADios = false}) async {
    final nuevaPromesa = Promesa(
      descripcion: descripcion,
      fechaCreacion: DateTime.now(),
      fechaFinalizacion: fechaFinalizacion,
      esPromesaADios: esPromesaADios, // Usar el parámetro
    );
    
    await DBServicio.instancia.crear(nuevaPromesa);
    await cargarDatos();
  }


  Future<void> actualizarPromesa(Promesa promesa) async {
    await DBServicio.instancia.actualizar(promesa);
    await cargarDatos();
  }

  Future<void> moverAPapelera(int id, {String? razon}) async {
    final promesa = await DBServicio.instancia.leerPromesa(id);
    if (promesa != null) {
      promesa.fechaEliminacion = DateTime.now();
      promesa.razonEliminacion = razon;
      await DBServicio.instancia.actualizar(promesa);
      await cargarDatos();
    }
  }

  Future<void> restaurarPromesa(int id) async {
    final promesa = await DBServicio.instancia.leerPromesa(id);
    if (promesa != null) {
      promesa.fechaEliminacion = null;
      promesa.razonEliminacion = null;
      await DBServicio.instancia.actualizar(promesa);
      await cargarDatos();
    }
  }
  
  Future<void> eliminarPermanentemente(int id) async {
    await DBServicio.instancia.eliminarPermanentemente(id);
    await cargarDatos();
  }

  // --- NUEVA FUNCIÓN ---
  Future<void> marcarComoCompletada(int id, bool completada) async {
    final promesa = await DBServicio.instancia.leerPromesa(id);
    if (promesa != null) {
      promesa.completada = completada;
      await DBServicio.instancia.actualizar(promesa);
      await cargarDatos();
    }
  }
}