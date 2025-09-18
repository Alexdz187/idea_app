import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelos/promesa.dart';
import '../modelos/objetivo.dart';
import '../modelos/entrada_diario.dart';

class DBServicio {
  static final DBServicio instancia = DBServicio._init();
  static Database? _database;

  DBServicio._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('promesas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // Incrementamos la versión de la DB para forzar la actualización del esquema
    return await openDatabase(path, version: 2, onCreate: _crearDB, onUpgrade: _onUpgradeDB);
  }

  Future _crearDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const nullableTextType = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const dateType = 'TEXT';

    await db.execute('''
      CREATE TABLE promesas ( 
        id $idType, 
        descripcion $textType,
        fechaCreacion $dateType,
        fechaFinalizacion $dateType,
        completada $intType,
        fechaEliminacion $dateType,
        razonEliminacion $nullableTextType,
        esPromesaADios $intType DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE objetivos (
        id $idType,
        descripcion $textType,
        completado $intType
      )
    ''');
    
    await db.execute('''
      CREATE TABLE diario (
        id $idType,
        contenido $textType,
        fecha $dateType
      )
    ''');
  }

  // Función para manejar actualizaciones del esquema
  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE promesas ADD COLUMN esPromesaADios INTEGER DEFAULT 0');
    }
  }

  // --- El resto de las funciones CRUD no necesitan cambios ---
  // ... (crear, leer, actualizar, etc.)
  Future<Promesa> crear(Promesa promesa) async {
    final db = await instancia.database;
    final id = await db.insert('promesas', promesa.toMap());
    promesa.id = id;
    return promesa;
  }
  Future<Promesa?> leerPromesa(int id) async {
    final db = await instancia.database;
    final maps = await db.query('promesas', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Promesa.fromMap(maps.first) : null;
  }
  Future<List<Promesa>> leerTodasLasPromesas() async {
    final db = await instancia.database;
    final result = await db.query('promesas',
        where: 'fechaEliminacion IS NULL', orderBy: 'fechaCreacion DESC');
    return result.map((json) => Promesa.fromMap(json)).toList();
  }
  Future<List<Promesa>> leerPromesasEliminadas() async {
    final db = await instancia.database;
    final result = await db.query('promesas',
        where: 'fechaEliminacion IS NOT NULL', orderBy: 'fechaEliminacion DESC');
    return result.map((json) => Promesa.fromMap(json)).toList();
  }
  Future<int> actualizar(Promesa promesa) async {
    final db = await instancia.database;
    return db.update('promesas', promesa.toMap(), where: 'id = ?', whereArgs: [promesa.id]);
  }
  Future<int> eliminarPermanentemente(int id) async {
    final db = await instancia.database;
    return await db.delete('promesas', where: 'id = ?', whereArgs: [id]);
  }
  Future<Objetivo> crearObjetivo(Objetivo objetivo) async {
    final db = await instancia.database;
    final id = await db.insert('objetivos', objetivo.toMap());
    objetivo.id = id;
    return objetivo;
  }
  Future<List<Objetivo>> leerTodosLosObjetivos() async {
    final db = await instancia.database;
    final result = await db.query('objetivos', orderBy: 'id DESC');
    return result.map((json) => Objetivo.fromMap(json)).toList();
  }
  Future<int> actualizarObjetivo(Objetivo objetivo) async {
    final db = await instancia.database;
    return db.update('objetivos', objetivo.toMap(), where: 'id = ?', whereArgs: [objetivo.id]);
  }
  Future<int> eliminarObjetivo(int id) async {
    final db = await instancia.database;
    return db.delete('objetivos', where: 'id = ?', whereArgs: [id]);
  }
  Future<EntradaDiario> crearEntradaDiario(EntradaDiario entrada) async {
    final db = await instancia.database;
    final id = await db.insert('diario', entrada.toMap());
    entrada.id = id;
    return entrada;
  }
  Future<EntradaDiario?> leerEntradaDiario(int id) async {
    final db = await instancia.database;
    final maps = await db.query('diario', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? EntradaDiario.fromMap(maps.first) : null;
  }
  Future<List<EntradaDiario>> leerTodasLasEntradas() async {
    final db = await instancia.database;
    final result = await db.query('diario', orderBy: 'fecha DESC');
    return result.map((json) => EntradaDiario.fromMap(json)).toList();
  }
  Future<int> actualizarEntradaDiario(EntradaDiario entrada) async {
    final db = await instancia.database;
    return db.update('diario', entrada.toMap(), where: 'id = ?', whereArgs: [entrada.id]);
  }
  Future<int> eliminarEntradaDiario(int id) async {
    final db = await instancia.database;
    return db.delete('diario', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instancia.database;
    db.close();
  }
}