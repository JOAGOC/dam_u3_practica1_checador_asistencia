import 'package:dam_u3_practica1_checador_asistencia/Modelo/Horario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/HorarioConsultado.dart';
import 'package:dam_u3_practica1_checador_asistencia/conexion.dart';

class DBHorario {
  static Future<int> registrar(Horario h) async {
    var db = await ConexionDB.abrirDB();
    var horario = h.toJSON();
    horario.remove('NHORARIO');
    return db.insert('HORARIO', horario);
  }

  static Future<List<HorarioConsultado>> consultar([String? nprofesor]) async {
    var db = await ConexionDB.abrirDB();
    var resultado = await db.rawQuery("""
      SELECT *
      FROM HORARIO, PROFESOR, MATERIA
      WHERE HORARIO.NPROFESOR = PROFESOR.NPROFESOR
      AND HORARIO.NMAT = MATERIA.NMAT
      ${nprofesor!=null?' AND PROFESOR.NPROFESOR = $nprofesor':''} 
      ${nprofesor!= null? 'GROUP BY MATERIA.NMAT': ""};
    """);
    return List.generate(
        resultado.length,
            (index) => HorarioConsultado(
            nhorario: int.parse(resultado[index]["NHORARIO"].toString()),
            nprofesor: resultado[index]["NPROFESOR"].toString(),
            nmat: resultado[index]["NMAT"].toString(),
            hora: resultado[index]["HORA"].toString(),
            edificio: resultado[index]["EDIFICIO"].toString(),
            salon: resultado[index]["SALON"].toString(),
            descripcion: resultado[index]["DESCRIPCION"].toString(),
            nombre: resultado[index]["NOMBRE"].toString(),
            carrera: resultado[index]["CARRERA"].toString()));
  }

  static Future<int> actualizar(Horario h) async {
    var db = await ConexionDB.abrirDB();
    var horario = h.toJSON();
    horario.remove('NHORARIO');
    return db.update('HORARIO', horario,
        where: 'NHORARIO=?', whereArgs: [h.nhorario]);
  }

  static Future<int> eliminar(int nhorario) async {
    var db = await ConexionDB.abrirDB();
    return db.delete('HORARIO', where: 'NHORARIO=?', whereArgs: [nhorario]);
  }
}
