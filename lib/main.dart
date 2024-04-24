import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIProfesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIAsistencia.dart';

import 'package:dam_u3_practica1_checador_asistencia/Modelo/HorarioConsultado.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/asistencia.dart';
import 'package:flutter/material.dart';

import 'Controlador/DBAsistencia.dart';
import 'Controlador/DBprofesor.dart';
import 'Modelo/horario_asistencia.dart';
import 'Modelo/profesor.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int _indice = 0;
  List<Materia> materias = [];
  List<Profesor> profesor = [];
  List<HorarioConsultado> horario = [];
  List<Horario_Asistencia> asistencialist = [];

  // BottomNavigator
  static const List<MaterialColor> colores = [
    Colors.green,
    Colors.amber,
    Colors.red,
    Colors.blue,
  ];
  static List<IconData> iconos = [
    Icons.menu_book_sharp,
    Icons.school,
    Icons.access_time_filled,
    Icons.format_list_numbered
  ];
  // BottomNavigator

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarMaterias();
    consultarProfesor();
    consultarHorario();
    consultarAsistencia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CHECADOR",
          style: TextStyle(
            fontSize: 30,
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
        centerTitle: true,
        backgroundColor: colores[_indice],
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(iconos[0]),
              label: "Materia",
              backgroundColor: colores[0]),
          BottomNavigationBarItem(
              icon: Icon(iconos[1]),
              label: "Profesor",
              backgroundColor: colores[1]),
          BottomNavigationBarItem(
              icon: Icon(iconos[2]),
              label: "Horario",
              backgroundColor: colores[2]),
          BottomNavigationBarItem(
              icon: Icon(iconos[3]),
              label: "Asistencia",
              backgroundColor: colores[3]),
        ],
        currentIndex: _indice,
        onTap: (index) {
          setState(() {
            _indice = index;
          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: colores[_indice],
          onPressed: () {
            switch (_indice) {
              case 0:
                GUIMateria.formularioRegistrar(this, true);
              case 1:
                GUIProfesor.formularioRegistrar(this, true);
              case 2:
                GUIHorario.formularioRegistrar(this, true);
              case 3 :
                GUIAsistencia.formularioRegistrar(this, true);
            }
          },
          child: Row(
            children: [
              Icon(iconos[_indice],color: colores[_indice].shade100,),
              Icon(
                Icons.add,
                color: colores[_indice].shade100,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )),
    );
  }

  dinamico() {
    switch (_indice) {
      case 0:return GUIMateria.listaMaterias(this);
      case 1: return GUIProfesor.listaProfesor(this);
      case 2: return GUIHorario.listaHorario(this);
      case 3: return GUIAsistencia.listaAsistencia(this);
      default:
        return GUIMateria.listaMaterias(this);
    }
  }

  void consultarMaterias() async {
    var x = await DBMateria.consultar();
    setState(() {
      materias = x;
    });
  }

  void consultarProfesor() async {
    var x = await DBprofesor.consultar();
    setState(() {
      profesor = x;
    });
  }

  void mensaje(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  void consultarHorario() async {
    var x = await DBHorario.consultar();
    setState(() {
      horario = x;
    });
  }

  void consultarAsistencia() async {
    var x = await DBAsistencia.consultar();
    setState(() {
      asistencialist = x;
    });
  }
}
