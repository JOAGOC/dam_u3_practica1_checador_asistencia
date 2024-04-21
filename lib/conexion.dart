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
    db.execute("""
      CREATE TABLE MATERIA(
        NMAT		TEXT	PRIMARY KEY,
        DESCRIPCION	TEXT
      );
      
      CREATE TABLE PROFESOR(
        NPROFESOR	TEXT	PRIMARY KEY,
        NOMBRE	  	TEXT,
        CARRERA	 	TEXT
      );
      
      CREATE TABLE HORARIO(
        NHORARIO	INT PRIMARY KEY AUTOINCREMENT,
        NPROFESOR	TEXT,
        NMAT		TEXT,
        HORA		TEXT,
        EDIFICIO	TEXT,
        SALON		TEXT,
        FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR (NPROFESOR),
        FOREIGN KEY (NMAT) REFERENCES MATERIA (NMAT)
      );
      
      CREATE TABLE ASISTENCIA(
        IDASISTENCIA 	INT PRIMARY KEY AUTOINCREMENT,
        NHORARIO 		INT,
        FECHA 			TEXT,
        ASISTENCIA		BOOLEAN
      );
    """);
  }
}
