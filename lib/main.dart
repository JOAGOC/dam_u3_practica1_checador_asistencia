import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIConsultarAsistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIConsultarHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIConsultarMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIProfesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIAsistencia.dart';

import 'package:dam_u3_practica1_checador_asistencia/Modelo/HorarioConsultado.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
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
  int _indicedrawer = 0;
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
              case 3:
                GUIAsistencia.formularioRegistrar(this, true);
            }
          },
          child: Row(
            children: [
              Icon(
                iconos[_indice],
                color: colores[_indice].shade100,
              ),
              Icon(
                Icons.add,
                color: colores[_indice].shade100,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(color: Colors.green),
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/logo.png'),
                      // Ejemplo de imagen personalizada
                      radius: 40,
                    ),
                    Text("CHECADOR",
                        style: TextStyle(
                          fontSize: 24,
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
                        )),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.green],
                  ),
                ),
              ),
              //SizedBox(height: 20),
              itemDrawer(1, Icons.menu_book_sharp, "Consulta Materias"),
              Divider(color: Colors.white),
              itemDrawer(2, Icons.list_alt_rounded, "Consulta Asistencias"),
              Divider(color: Colors.white), // Separador personalizado
              itemDrawer(3, Icons.access_time_filled, "Consulta Horarios"),
              Divider(color: Colors.white), // Separador personalizado
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDrawer(int indice, IconData icono, String etiqueta) {
    return ListTile(
      onTap: () {
        setState(() {
          _indicedrawer = indice;
        });
        if (_indicedrawer == 1) {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GUIConsultarMateria();
          }));
        } else {
          if (_indicedrawer == 2) {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GUIConsultarAsistencia();
            }));
          } else {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return GUIConsultarHorario();
            }));
          }
        }
      },
      title: Row(
        children: [
          Expanded(
            child: Icon(
              icono,
              color: Colors.white, // Color del ícono
              size: 28, // Tamaño del ícono
            ),
          ),
          SizedBox(width: 10), // Espacio entre el ícono y el texto
          Expanded(
            flex: 2,
            child: Text(
              etiqueta,
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 24, // Tamaño del texto
                fontWeight: FontWeight.bold, // Negrita del texto
              ),
            ),
          ),
        ],
      ),
    );
  }

  dinamico() {
    switch (_indice) {
      case 0:
        return GUIMateria.listaMaterias(this);
      case 1:
        return GUIProfesor.listaProfesor(this);
      case 2:
        return GUIHorario.listaHorario(this);
      case 3:
        return GUIAsistencia.listaAsistencia(this);
      case 4:
        return consultamateria();
      default:
        return GUIMateria.listaMaterias(this);
    }
  }

  Widget consultamateria() {
    return ListView();
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
