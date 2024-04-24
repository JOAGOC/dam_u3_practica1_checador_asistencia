import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBprofesor.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
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
                    padding: GUIEstandar.paddingFormulario,
                    children: [
                  Text(
                    '${registrar
                        ? "Agregar un nuevo"
                        : "Actualizar "} Profesor',
                    style: GUIEstandar.estiloTextoBoton,
                    textAlign: TextAlign.center,
                  ),
                  GUIEstandar.espacioEntreCampos,
                  TextField(
                    controller: nprofe,
                    decoration: const InputDecoration(
                      labelText: "Número ID",
                      suffixIcon: Icon(Icons.numbers_sharp),
                    ),
                  ),
                  GUIEstandar.espacioEntreCampos,
                  TextField(
                    controller: nombreprofe,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      suffixIcon: Icon(Icons.person),
                    ),
                  ),
                  GUIEstandar.espacioEntreCampos,
                  TextField(
                    controller: carreraprofe,
                    decoration: const InputDecoration(
                      labelText: "Carrera",
                      suffixIcon: Icon(Icons.star),
                    ),
                  ),
                  GUIEstandar.espacioEntreCampos,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: GUIEstandar.estiloCancelarFormulario,
                        child: const Text(
                          "Cancelar",
                          style: GUIEstandar.estiloTextoBoton,
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
                          style: GUIEstandar.estiloAceptarFormulario,
                          child: Text(registrar ? 'Registrar' : 'Actualizar',
                              style: GUIEstandar.estiloTextoBoton))
                    ],
                  ),
                ])));
  }

  static Widget listaProfesor(MyAppState app) {
    var profesor = app.profesor;
    if (profesor.isNotEmpty) {
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
                      icon: const Icon(Icons.mode),
                      onPressed: () {
                        formularioRegistrar(app, false, profesor[index]);
                      }),
                  IconButton(
                      onPressed: () {
                        borrar(app, profesor[index]);
                      },
                      icon: const Icon(Icons.delete))
                ],
              ),
            ),
      );
    } else {
      return GUIEstandar.listaVacia('No hay profesores registrados');
    }
  }

  static void borrar(MyAppState app, Profesor profesor) {
    showDialog(
      context: app.context,
      builder: (context) =>
          AlertDialog(
            title: const Text("Eliminar"),
            content: const Text("Deseas eliminar el Profesor?"),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancelar')),
              TextButton(
                  onPressed: () {
                    DBprofesor.eliminar(profesor.nprofesor).then((value) {
                      Navigator.pop(app.context);
                      app.consultarProfesor();
                      app.mensaje("Profesor eliminado con exito");
                    });
                  },
                  child: const Text('Si'))
            ],
          ),
    );
  }
}
