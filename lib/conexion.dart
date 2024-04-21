import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConexionDB {
  static Future<Database> abrirDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "checador.db"),
      onCreate: (db, version) => crearBD(db),
      version: 1,
    );
  }

  static Future<void> crearBD(Database db) async {
    await db.execute("""
    CREATE TABLE IF NOT EXISTS MATERIA(
      NMAT		TEXT	PRIMARY KEY,
      DESCRIPCION	TEXT
    );
  """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS PROFESOR(
      NPROFESOR	TEXT	PRIMARY KEY,
      NOMBRE	  	TEXT,
      CARRERA	 	TEXT
    );
  """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS HORARIO(
      NHORARIO	INTEGER PRIMARY KEY AUTOINCREMENT,
      NPROFESOR	TEXT,
      NMAT		TEXT,
      HORA		TEXT,
      EDIFICIO	TEXT,
      SALON		TEXT,
      FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR (NPROFESOR),
      FOREIGN KEY (NMAT) REFERENCES MATERIA (NMAT)
    );
  """);

    await db.execute("""
    CREATE TABLE IF NOT EXISTS ASISTENCIA(
      IDASISTENCIA 	INTEGER PRIMARY KEY AUTOINCREMENT,
      NHORARIO 		INTEGER,
      FECHA 			TEXT,
      ASISTENCIA	BOOLEAN
    );
  """);
  }
}
