import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBprofesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/profesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/main.dart';
import 'package:flutter/material.dart';

class GUIProfesor {
  static final nprofe = TextEditingController();
  static final nombreprofe = TextEditingController();
  static final carreraprofe = TextEditingController();

  static void formularioRegistrar(MyAppState app, bool registrar,
      [Profesor? profesor]) {
    if (profesor != null) {
      nprofe.text = profesor.nprofesor;
      nombreprofe.text = profesor.nombre;
      carreraprofe.text = profesor.carrera;
    }
    showModalBottomSheet(
        context: app.context,
        builder: (context) =>
            Container(
                padding: EdgeInsets.only(
                    top: 16,
                    left: 8,
                    right: 8,
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                  Text(
                    '${registrar
                        ? "Agregar un nuevo"
                        : "Actualizar "} Profesor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nprofe,
                    decoration: InputDecoration(
                      labelText: "Número ID",
                      suffixIcon: Icon(Icons.numbers_sharp),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: nombreprofe,
                    decoration: InputDecoration(
                      labelText: "Nombre",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: carreraprofe,
                    decoration: InputDecoration(
                      labelText: "Carrera",
                      suffixIcon: Icon(Icons.star),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            finalizar() {
                              Navigator.pop(context);
                              app.consultarProfesor();
                              nprofe.clear();
                              nombreprofe.clear();
                              carreraprofe.clear();
                            }

                            var p = Profesor(
                                nprofesor: nprofe.text,
                                nombre: nombreprofe.text,
                                carrera: carreraprofe.text);
                            registrar
                                ? DBprofesor.registrar(p).then((value) {
                              finalizar();
                              app.mensaje('Profesor registrado con éxito');
                            })
                                : DBprofesor.actualizar(p).then((value) {
                              finalizar();
                              app.mensaje('Profesor actualizado con éxito');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(registrar ? 'Registrar' : 'Actualizar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )))
                    ],
                  ),
                ])));
  }

  static Widget listaProfesor(MyAppState app) {
    var profesor = app.profesor;
    if (profesor.length > 0) {
      return ListView.builder(
        itemCount: profesor.length,
        itemBuilder: (context, index) =>
            ListTile(
              leading: CircleAvatar(child: Text(profesor[index].nprofesor)),
              title: Text(profesor[index].nombre),
              subtitle: Text(profesor[index].carrera),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.mode),
                      onPressed: () {
                        formularioRegistrar(app, false, profesor[index]);
                      }),
                  IconButton(
                      onPressed: () {
                        borrar(app, profesor[index]);
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            ),
      );
    } else {
      return Center(
        child: Text('No hay profesores registrados',
            style: TextStyle(color: Colors.black54)),
      );
    }
  }

  static void borrar(MyAppState app, Profesor profesor) {
    showDialog(
      context: app.context,
      builder: (context) =>
          AlertDialog(
            title: Text("Eliminar"),
            content: Text("Deseas eliminar el Profesor?"),
            actions: [
              TextButton(
                  onPressed: () {
                    DBprofesor.eliminar(profesor.nprofesor).then((value) {
                      Navigator.pop(app.context);
                      app.consultarProfesor();
                      app.mensaje("Profesor eliminado con exito");
                    });
                  },
                  child: Text('Si'))
            ],
          ),
    );
  }
}
