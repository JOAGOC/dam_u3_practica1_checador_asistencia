import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBMateria.dart';
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
          padding: EdgeInsets.all(16),
          children: [
            Text('${registrar ? "Registrar una nueva" : "Actualizar"} Materia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            espacioEntreCampos(),
            TextField(
              controller: nmat,
              decoration: InputDecoration(
                  labelText: 'NMAT (Clave)', suffixIcon: Icon(Icons.mode)),
            ),
            espacioEntreCampos(),
            TextField(
              controller: descripcion,
              decoration: InputDecoration(
                  labelText: 'Descripcion', suffixIcon: Icon(Icons.book)),
            ),
            espacioEntreCampos(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: estiloCancelarFormulario(),
                  child: Text(
                    "Cancelar",
                    style: estiloBotonFormulario(),
                  ),
                ),
                ElevatedButton(
                    style: estiloBotonAceptarFormulario(),
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
                      style: estiloBotonFormulario(),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  static SizedBox espacioEntreCampos() {
    return SizedBox(
      height: 20,
    );
  }

  static ButtonStyle estiloBotonAceptarFormulario() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  static TextStyle estiloBotonFormulario() {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  static Widget listaMaterias(MyAppState app) {
    var materias = app.materias;
    if (materias.length > 0)
      return ListView.builder(
        itemCount: materias.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(child: Text(materias[index].nmat)),
          title: Text(materias[index].descripcion),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, materias[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, materias[index]);
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
        ),
      );
    else
      return Center(
        child: Text('No hay materias registradas',
            style: TextStyle(color: Colors.black54)),
      );
  }

  static void borrar(MyAppState app, Materia materia) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar"),
        content: Text("Deseas eliminar la materia?"),
        actions: [
          TextButton(
              onPressed: () {
                DBMateria.eliminar(materia.nmat).then((value) {
                  Navigator.pop(app.context);
                  app.consultarMaterias();
                  app.mensaje("Materia eliminada con exito");
                });
              },
              child: Text('Si'))
        ],
      ),
    );
  }

  static estiloCancelarFormulario() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
