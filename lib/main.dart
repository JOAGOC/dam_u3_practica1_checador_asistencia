import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIProfesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
import 'package:flutter/material.dart';

import 'Controlador/DBprofesor.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    consultarMaterias();
    consultarProfesor();
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
        backgroundColor: Colors.green,
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: "Materia",
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Profesor",
              backgroundColor: Colors.yellowAccent.shade700),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled),
              label: "Horario",
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered),
              label: "Asistencia",
              backgroundColor: Colors.blue),
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
          backgroundColor: Colors.green,
          onPressed: () {
            switch(_indice){
              case 0: GUIMateria.formularioRegistrar(this, true);
              case 1: GUIProfesor.formularioRegistrar(this, true);
            }
          },
          child: Row(
            children: [
              Icon(Icons.menu_book, color: Colors.green.shade50),
              Icon(
                Icons.add,
                color: Colors.green.shade50,
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

}