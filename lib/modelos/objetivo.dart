class Objetivo {
  int? id;
  String descripcion;
  bool completado;

  Objetivo({
    this.id,
    required this.descripcion,
    this.completado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'completado': completado ? 1 : 0,
    };
  }

  factory Objetivo.fromMap(Map<String, dynamic> map) {
    return Objetivo(
      id: map['id'],
      descripcion: map['descripcion'],
      completado: map['completado'] == 1,
    );
  }
}