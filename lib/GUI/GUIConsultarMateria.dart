import 'package:dam_u3_practica1_checador_asistencia/Modelo/profesor.dart';
import 'package:flutter/material.dart';

import '../Controlador/DBHorario.dart';
import '../Controlador/DBprofesor.dart';
import '../Modelo/HorarioConsultado.dart';

class GUIConsultarMateria extends StatefulWidget {
  const GUIConsultarMateria({super.key});

  @override
  State<GUIConsultarMateria> createState() => _GUIConsultarMateriaState();
}

class _GUIConsultarMateriaState extends State<GUIConsultarMateria> {
  List<Profesor> listaProfesor = [];
  List<HorarioConsultado> recuMateria = [];

  String profesor = "";

  @override
  void initState() {
    consultarProfesor();
    super.initState();
  }

  void consultarProfesor() async {
    var x = await DBprofesor.consultar();
    setState(() {
      listaProfesor = x;
    });
    //consultarHorario();
  }

  void consultarHorario() async {
    var x = await DBHorario.consultar(profesor);
    setState(() {
      recuMateria = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Consultar materias de profesor",
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
            Text("Elige al Profesor",
              style: TextStyle(
                fontSize: 24, // Tamaño del texto
                fontStyle: FontStyle.italic, // Cursiva
                color: Colors.black, // Color del texto
              ),),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
                icon: Icon(Icons.access_time),
                items: listaProfesor.map((e) {
                  return DropdownMenuItem(
                    child: Text('${e.nombre} - ${e.carrera}',
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    value: e.nprofesor,
                  );
                }).toList(),
                onChanged: (value) {
                  profesor = value!;
                  if (listaProfesor.isNotEmpty) {
                    consultarHorario();
                  }
                }
            ),
            SizedBox(
              height: 30,
            ),
            Text("Materias que imparte:",
              style: TextStyle(
                fontSize: 24, // Tamaño del texto
                fontStyle: FontStyle.italic, // Cursiva
                color: Colors.black, // Color del texto
              ),),
            SizedBox(
              height: 30,
            ),
            listaAsistencia()
          ],
        ));
  }

  Widget listaAsistencia() {
    var Materialist = recuMateria;
    if (Materialist.length > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: Materialist.length,
        itemBuilder: (context, index) => ListTile(
          tileColor: _getColor(index), // Asigna el color de fondo dinámicamente
          leading: CircleAvatar(
            child: Text(
              Materialist[index].nmat.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.black, // Color de fondo del avatar
          ),
          title: Text(
            '${Materialist[index].descripcion}',
            style: TextStyle(
              fontSize: 18, // Tamaño del texto
              fontWeight: FontWeight.bold, // Negrita
              color: Colors.black, // Color del texto
            ),
          ),
          subtitle: Text(
            'Horario: ${Materialist[index].hora}', // Subtítulo con el horario
            style: TextStyle(
              fontSize: 14, // Tamaño del texto
              fontStyle: FontStyle.italic, // Cursiva
              color: Colors.black, // Color del texto
            ),
          ),
          onTap: () {
            // Acción al hacer clic en el ListTile
          },
        ),
      );
    } else {
      return Center(
        child: Text(
          'No hay Materias registradas',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16, // Tamaño del texto
            fontStyle: FontStyle.italic, // Cursiva
          ),
        ),
      );
    }
  }

  Color _getColor(int index) {
    // Lista de colores de fondo para los registros
    List<Color> colors = [
      Colors.blue.shade100,
      Colors.lightBlue.shade300,
      Colors.blueAccent.shade400,

    ];
    // Retorna un color de la lista según el índice del registro
    return colors[index % colors.length];
  }
}
