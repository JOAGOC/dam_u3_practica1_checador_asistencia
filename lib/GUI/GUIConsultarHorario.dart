import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBprofesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/HorarioConsultado.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/profesor.dart';
import 'package:flutter/material.dart';

class GUIConsultarHorario extends StatefulWidget {
  const GUIConsultarHorario({super.key});

  @override
  State<GUIConsultarHorario> createState() => _GUIConsultarHorarioState();
}

class _GUIConsultarHorarioState extends State<GUIConsultarHorario> {
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
            "Consultar Horarios",
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
          backgroundColor: Colors.red,
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
                  consultarHorarios();
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

  static var horario = <HorarioConsultado>[];

  static Widget listaAsistencia() {
    if (horario.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: horario.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text("${horario[index].nombre}"),
            subtitle: Text(
                '''Materia:${horario[index].descripcion} Hora:${horario[index].hora}
Edificio:${horario[index].edificio} Salon:${horario[index].salon}'''),
          ),
        ),
      );
    } else {
      return GUIEstandar.listaVacia('No hay Asistencias registradas');
    }
  }

  void consultarHorarios() async {
    var x = await DBHorario.consultar(nprofesor);
    setState(() {
      horario = x;
    });
  }
}
