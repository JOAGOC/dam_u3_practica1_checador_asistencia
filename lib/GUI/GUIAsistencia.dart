import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/horario_asistencia.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class GUIAsistencia {
  //static final idasistencia = TextEditingController();
  static int nhorario_hora = 0;
  static DateTime fecha = DateTime.now();
  static bool asistencia = true;
  static var fechaseleccionada = TextEditingController();

  static void formularioRegistrar(MyAppState app, bool registrar,
      [Horario_Asistencia? a]) {

    if (app.horario.isNotEmpty) {
      nhorario_hora = app.horario.first.nhorario;
    }
    if (a != null) {
      nhorario_hora = a.nhorario;
      fechaseleccionada.text = a.fecha;
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
            Text(
                '${registrar ? "Registrar una nueva" : "Actualizar"} Asistencia',
                textAlign: TextAlign.center),
            SizedBox(
              height: 16,
            ),
            Text('Seleccionar Horario:'),
            DropdownButtonFormField(
                icon: Icon(Icons.access_time),
                value: nhorario_hora,
                items: app.horario.map((e) {
                  return DropdownMenuItem(
                    child: Text('${e.hora} - ${e.nombre}'),
                    value: e.nhorario,
                  );
                }).toList(),
                onChanged: (value) => nhorario_hora = value!),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: fechaseleccionada,
              readOnly: true,
              decoration: InputDecoration(label: Text("Fecha seleccionada:")),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101));
                if (picked != null && picked != fecha) {
                  fecha = picked;
                }
                fechaseleccionada.text = fecha == null
                    ? 'No se ha seccionado fecha'
                    : '${fecha.toLocal().toIso8601String().split('T')[0]}';
              },
              child: Text('Seleccionar fecha'),
            ),
            SizedBox(
              height: 23,
            ),
            Text('¿ASISTIO?'),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      asistencia = true;
                      registrarOActualizar(context, app, registrar, a);
                    },
                    child: Text("Sí")),
                ElevatedButton(
                    onPressed: () {
                      asistencia = false;
                      registrarOActualizar(context, app, registrar, a);
                    },
                    child: Text("No")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void registrarOActualizar(
      BuildContext context, MyAppState app, bool registrar,
      [Horario_Asistencia? a]) {
    finalizar() {
      Navigator.pop(context);
      app.consultarAsistencia();
      fechaseleccionada.clear();
    }

    var m = Asistencia(
        idasistencia: a?.idasistencia,
        nhorario: nhorario_hora,
        fecha: fecha.toLocal().toIso8601String().split('T')[0],
        asistencia: asistencia);
    registrar
        ? DBAsistencia.registrar(m).then((value) {
            finalizar();
            app.consultarAsistencia();
            app.mensaje('Asistencia registrada con exito');
          })
        : DBAsistencia.actualizar(m).then((value) {
            finalizar();
            app.consultarAsistencia();
            app.mensaje('Asistencia actualizada con exito');
          });
  }

  static Widget listaAsistencia(MyAppState app) {
    var asistencia = app.asistencialist;
    if (asistencia.length > 0)
      return ListView.builder(
        itemCount: asistencia.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
              child: Text(asistencia[index].idasistencia.toString())),
          title:
              Text('${asistencia[index].nombre} - ${asistencia[index].fecha}'),
          subtitle: Text(
              '${asistencia[index].asistencia} - ${asistencia[index].hora}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, asistencia[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, asistencia[index]);
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
        ),
      );
    else
      return Center(
        child: Text('No hay Asistencias registradas',
            style: TextStyle(color: Colors.black54)),
      );
  }

  static void borrar(MyAppState app, Horario_Asistencia asistencia) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar"),
        content: Text("Deseas eliminar la Asistencia?"),
        actions: [
          TextButton(
              onPressed: () {
                DBAsistencia.eliminar(asistencia.idasistencia).then((value) {
                  Navigator.pop(app.context);
                  app.consultarAsistencia();
                  app.mensaje("Asistencia eliminada con exito");
                });
              },
              child: Text('Si'))
        ],
      ),
    );
  }
}
