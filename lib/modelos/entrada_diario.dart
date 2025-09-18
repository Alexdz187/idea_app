class EntradaDiario {
  int? id;
  String contenido;
  DateTime fecha;

  EntradaDiario({
    this.id,
    required this.contenido,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contenido': contenido,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory EntradaDiario.fromMap(Map<String, dynamic> map) {
    return EntradaDiario(
      id: map['id'],
      contenido: map['contenido'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}