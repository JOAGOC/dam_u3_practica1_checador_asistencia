import 'package:dam_u3_practica1_checador_asistencia/Modelo/profesor.dart';
import 'package:sqflite/sqflite.dart';

import '../conexion.dart';

class DBprofesor{

  static Future<List<Profesor>> consultar() async{
    Database base = await ConexionDB.abrirDB();
    var resultado = await base.query("PROFESOR");
    return List.generate(resultado.length, (index) {
      return Profesor(
          nprofesor: resultado[index]["NPROFESOR"].toString(),
          nombre: resultado[index]["NOMBRE"].toString(),
          carrera: resultado[index]["CARRERA"].toString(),
      );
    });
  }
  static Future<int> registrar(Profesor p) async{
      Database base = await ConexionDB.abrirDB();
      return base.insert("PROFESOR", p.toJSON(),
      conflictAlgorithm: ConflictAlgorithm.fail);
  }
  static Future<int> eliminar(String nprofesor) async{
    Database base = await ConexionDB.abrirDB();
    return base.delete("PROFESOR",where: "NPROFESOR=?",
        whereArgs: [nprofesor]);
  }

  static Future<int> actualizar (Profesor p ) async{
    Database base= await ConexionDB.abrirDB();
    var profe = p.toJSON();
    profe.remove('NPROFESOR');
    return base.update("PROFESOR", p.toJSON(), where: "NPROFESOR=?", whereArgs: [p.nprofesor]);
  }
}