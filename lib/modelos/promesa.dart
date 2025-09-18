class Promesa {
  int? id;
  String descripcion;
  DateTime fechaCreacion;
  DateTime? fechaFinalizacion;
  bool completada;
  DateTime? fechaEliminacion;
  String? razonEliminacion;
  bool esPromesaADios; // CAMPO NUEVO

  Promesa({
    this.id,
    required this.descripcion,
    required this.fechaCreacion,
    this.fechaFinalizacion,
    this.completada = false,
    this.fechaEliminacion,
    this.razonEliminacion,
    this.esPromesaADios = false, // VALOR POR DEFECTO
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaFinalizacion': fechaFinalizacion?.toIso8601String(),
      'completada': completada ? 1 : 0,
      'fechaEliminacion': fechaEliminacion?.toIso8601String(),
      'razonEliminacion': razonEliminacion,
      'esPromesaADios': esPromesaADios ? 1 : 0, // AÑADIDO
    };
  }

  factory Promesa.fromMap(Map<String, dynamic> map) {
    return Promesa(
      id: map['id'],
      descripcion: map['descripcion'],
      fechaCreacion: DateTime.parse(map['fechaCreacion']),
      fechaFinalizacion: map['fechaFinalizacion'] != null
          ? DateTime.parse(map['fechaFinalizacion'])
          : null,
      completada: map['completada'] == 1,
      fechaEliminacion: map['fechaEliminacion'] != null
          ? DateTime.parse(map['fechaEliminacion'])
          : null,
      razonEliminacion: map['razonEliminacion'],
      esPromesaADios: map['esPromesaADios'] == 1, // AÑADIDO
    );
  }
}