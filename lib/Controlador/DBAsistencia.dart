import 'package:dam_u3_practica1_checador_asistencia/Modelo/Horario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/conexion.dart';

import '../Modelo/horario_asistencia.dart';

class DBAsistencia {
  static Future<int> registrar(Asistencia a) async {
    var db = await ConexionDB.abrirDB();
    var asistencia = a.toJSON();
    asistencia.remove('IDASISTENCIA');
    return db.insert('ASISTENCIA', asistencia);
  }

  static Future<List<Horario_Asistencia>> consultar() async {
    var db = await ConexionDB.abrirDB();
    var resultado = await db.rawQuery("""
      SELECT *
      FROM HORARIO, PROFESOR, MATERIA, ASISTENCIA
      WHERE HORARIO.NPROFESOR = PROFESOR.NPROFESOR
      AND HORARIO.NMAT = MATERIA.NMAT 
      AND HORARIO.NHORARIO = ASISTENCIA.NHORARIO;
    """);
    return List.generate(
        resultado.length,
            (index) => Horario_Asistencia(
                nhorario: int.parse(resultado[index]["NHORARIO"].toString()),
                nprofesor: resultado[index]["NPROFESOR"].toString(),
                nmat: resultado[index]["NMAT"].toString(),
                hora: resultado[index]["HORA"].toString(),
                edificio: resultado[index]["EDIFICIO"].toString(),
                salon: resultado[index]["SALON"].toString(),
                descripcion: resultado[index]["DESCRIPCION"].toString(),
                nombre: resultado[index]["NOMBRE"].toString(),
                carrera: resultado[index]["CARRERA"].toString(),
                asistencia: resultado[index]["ASISTENCIA"]==1,
                fecha: resultado[index]["FECHA"].toString(),
                idasistencia: int.parse(resultado[index]["IDASISTENCIA"].toString()),
            )
    );

  }

  static Future<int> actualizar(Asistencia a) async {
    var db = await ConexionDB.abrirDB();
    var horario = a.toJSON();
    horario.remove('IDASISTENCIA');
    return db.update('ASISTENCIA', horario,
        where: 'IDASISTENCIA=?', whereArgs: [a.idasistencia]);
  }

  static Future<int> eliminar(int idasistencia) async {
    var db = await ConexionDB.abrirDB();
    return db.delete('ASISTENCIA', where: 'IDASISTENCIA=?', whereArgs: [idasistencia]);
  }
}
