import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
import 'package:dam_u3_practica1_checador_asistencia/conexion.dart';

class DBMateria{
  static Future<int> registrar(Materia m) async {
    var db = await ConexionDB.abrirDB();
    return db.insert('MATERIA', m.toJSON());
  }

  static Future<List<Materia>> consultar() async {
    var db = await ConexionDB.abrirDB();
    var resultado = await db.query('MATERIA');
    return List.generate(resultado.length, (index) =>
      Materia(nmat: resultado[index]['NMAT'].toString(), descripcion: resultado[index]['DESCRIPCION'].toString())
    );
  }

  static Future<int> actualizar(Materia m) async {
    var db = await ConexionDB.abrirDB();
    var mat = m.toJSON();
    mat.remove('NMAT');
    return db.update('MATERIA', mat,where: 'NMAT=?',whereArgs: [m.nmat]);
  }

  static Future<int> eliminar(String nmat) async {
    var db = await ConexionDB.abrirDB();
    return db.delete('MATERIA',where: 'NMAT=?',whereArgs: [nmat]);
  }
}