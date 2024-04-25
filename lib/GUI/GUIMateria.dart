import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
import 'package:dam_u3_practica1_checador_asistencia/main.dart';
import 'package:flutter/material.dart';

class GUIMateria {
  static final nmat = TextEditingController();
  static final descripcion = TextEditingController();

  static void formularioRegistrar(MyAppState app, bool registrar,
      [Materia? m]) {
    if (m != null) {
      nmat.text = m.nmat;
      descripcion.text = m.descripcion;
    }
    showModalBottomSheet(
      context: app.context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            top: 16,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          padding: GUIEstandar.paddingFormulario,
          children: [
            Text('${registrar ? "Registrar una nueva" : "Actualizar"} Materia',
                textAlign: TextAlign.center,
                style: GUIEstandar.estiloTextoBoton),
            GUIEstandar.espacioEntreCampos,
            TextField(
              controller: nmat,
              decoration: const InputDecoration(
                  labelText: 'NMAT (Clave)', suffixIcon: Icon(Icons.mode)),
            ),
            GUIEstandar.espacioEntreCampos,
            TextField(
              controller: descripcion,
              decoration: const InputDecoration(
                  labelText: 'Descripcion', suffixIcon: Icon(Icons.book)),
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
                    style: GUIEstandar.estiloAceptarFormulario,
                    onPressed: () {
                      finalizar() {
                        Navigator.pop(context);
                        app.consultarMaterias();
                        nmat.clear();
                        descripcion.clear();
                      }

                      var m = Materia(
                        nmat: nmat.text,
                        descripcion: descripcion.text,
                      );
                      registrar
                          ? DBMateria.registrar(m).then((value) {
                              finalizar();
                              app.mensaje('Materia registrada con exito');
                            })
                          : DBMateria.actualizar(m).then((value) {
                              finalizar();
                              app.mensaje('Materia actualizada con exito');
                            });
                    },
                    child: Text(
                      registrar ? 'Registrar' : 'Actualizar',
                      style: GUIEstandar.estiloTextoBoton,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
  
  static Widget listaMaterias(MyAppState app) {
    var materias = app.materias;
    if (materias.isNotEmpty) {
      return ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(child: Text(materias[index].nmat)),
          title: Text(materias[index].descripcion),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, materias[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, materias[index]);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else{
      return GUIEstandar.listaVacia('No hay materias registradas');
    }
  }

  static void borrar(MyAppState app, Materia materia) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("Deseas eliminar la materia?"),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                DBMateria.eliminar(materia.nmat).then((value) {
                  Navigator.pop(app.context);
                  app.consultarMaterias();
                  app.mensaje("Materia eliminada con exito");
                });
              },
              child: const Text('Si'))
        ],
      ),
    );
  }
}
