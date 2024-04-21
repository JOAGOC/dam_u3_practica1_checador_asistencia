import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Materia.dart';
import 'package:dam_u3_practica1_checador_asistencia/main.dart';
import 'package:flutter/material.dart';

class GUIMateria {
  static void formularioRegistrar(MyAppState app, bool registrar) {
    var nmat = app.nmat;
    var descripcion = app.descripcion;

    showModalBottomSheet(
      context: app.context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            top: 16,
            left: 8,
            right: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text('${registrar ? "Registrar una nueva" : "Actualizar"} Materia',
                textAlign: TextAlign.center),
            SizedBox(height: 16,),
            TextField(
              controller: nmat,
              decoration: InputDecoration(
                  labelText: 'NMAT:', suffixIcon: Icon(Icons.mode)),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: descripcion,
              decoration: InputDecoration(
                  labelText: 'Descripcion:', suffixIcon: Icon(Icons.book)),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
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
                child: Text(registrar ? 'Registrar' : 'Actualizar'))
          ],
        ),
      ),
    );
  }

  static Widget listaMaterias(MyAppState app) {
    var materias = app.materias;
    if (materias.length>0)
    return ListView.builder(
      itemCount: app.materias.length,
      itemBuilder: (context, index) =>
          ListTile(
            leading: CircleAvatar(child: Text(materias[index].nmat)),
            title: Text(materias[index].descripcion),
            trailing:
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.mode), onPressed: () {
                  app.nmat.text = materias[index].nmat;
                  app.descripcion.text = materias[index].descripcion;
                  formularioRegistrar(app, false);
                }),
                IconButton(onPressed: () {
                  borrar(app,materias[index]);
                }, icon: Icon(Icons.delete))
              ],
            ),
          ),
    );
    else
      return Center(child: Text('No hay materias registradas',style: TextStyle(color: Colors.black54)),);
  }

  static void borrar(MyAppState app, Materia materia) {
    showDialog(context: app.context, builder: (context) => AlertDialog(
      title: Text("Eliminar"),
      content: Text("Deseas eliminar la materia?"),
      actions: [
        TextButton(onPressed: (){
          DBMateria.eliminar(materia.nmat).then((value) {
            Navigator.pop(app.context);
            app.consultarMaterias();
            app.mensaje("Materia eliminada con exito");
          });
        }, child: Text('Si'))
      ],
    ),);
  }
}
