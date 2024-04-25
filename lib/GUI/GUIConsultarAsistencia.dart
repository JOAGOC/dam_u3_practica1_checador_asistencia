import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBprofesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/horario_asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/profesor.dart';
import 'package:flutter/material.dart';

class GUIConsultarAsistencia extends StatefulWidget {
  const GUIConsultarAsistencia({super.key});

  @override
  State<GUIConsultarAsistencia> createState() => _GUIConsultarAsistenciaState();
}

class _GUIConsultarAsistenciaState extends State<GUIConsultarAsistencia> {
  static var listaProfesor = <Profesor>[];
  String nprofesor = '';

  @override
  void initState() {
    super.initState();
    consultarProfesor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Consultar Asistencia",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: Colors.white,
              letterSpacing: 2.0,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: ListView(
          padding: EdgeInsets.all(40),
          children: [
            Text("Elige al Profesor"),
            DropdownButtonFormField(
                icon: Icon(Icons.access_time),
                items: listaProfesor.map((e) {
                  return DropdownMenuItem(
                    child: Text('${e.nombre} - ${e.carrera}'),
                    value: e.nprofesor,
                  );
                }).toList(),
                onChanged: (value) {
                  nprofesor = value!;
                  consultarAsistencias();
                }),
            GUIEstandar.espacioEntreCampos,
            listaAsistencia()
          ],
        ));
  }

  void consultarProfesor() async {
    var x = await DBprofesor.consultar();
    setState(() {
      listaProfesor = x;
    });
  }

  static var asistencia = <Horario_Asistencia>[];

  static Widget listaAsistencia() {
    if (asistencia.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: asistencia.length,
        itemBuilder: (context, index) => Card(
          color: (asistencia[index].asistencia?Colors.green.shade300:Colors.red.shade300),
          child: ListTile(
            title:
            Text(asistencia[index].nombre, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                '''Fecha: ${asistencia[index].fecha} Hora: ${asistencia[index].hora}
Materia: ${asistencia[index].descripcion}
${asistencia[index].asistencia?'Asistió':'No Asistió'}
          ''',style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      );
    } else {
      return GUIEstandar.listaVacia('No hay Asistencias registradas');
    }
  }

  void consultarAsistencias() async {
    var x = await DBAsistencia.consultar(nprofesor);
    setState(() {
      asistencia =  x;
    });
  }
}