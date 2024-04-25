import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBAsistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/horario_asistencia.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class GUIAsistencia {
  //static final idasistencia = TextEditingController();
  static int nhorario = 0;
  static DateTime fecha = DateTime.now();
  static bool asistencia = true;
  static var fechaseleccionada = TextEditingController();

  static void formularioRegistrar(MyAppState app, bool registrar,
      [Horario_Asistencia? a]) {

    if (app.horario.isNotEmpty) {
      nhorario = app.horario.first.nhorario;
    }
    if (a != null) {
      nhorario = a.nhorario;
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
          padding: GUIEstandar.paddingFormulario,
          children: [
            Text(
                '${registrar ? "Registrar una nueva" : "Actualizar"} Asistencia',
                textAlign: TextAlign.center,style: GUIEstandar.estiloTextoBoton),
            GUIEstandar.espacioEntreCampos,
            const Text('Seleccionar Horario:'),
            DropdownButtonFormField(
                icon: const Icon(Icons.access_time),
                value: nhorario,
                items: app.horario.map((e) {
                  return DropdownMenuItem(
                    value: e.nhorario,
                    child: Text('${e.hora} - ${e.nombre}\n${e.descripcion}'),
                  );
                }).toList(),
                onChanged: (value) => nhorario = value!),
            GUIEstandar.espacioEntreCampos,
            TextField(
              controller: fechaseleccionada,
              readOnly: true,
              decoration: const InputDecoration(label: Text("Fecha seleccionada:")),
            ),
            GUIEstandar.espacioEntreCampos,
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101));
                if (picked != null && picked != fecha) {
                  fecha = picked;
                }
                // ignore: unnecessary_null_comparison
                fechaseleccionada.text = fecha == null
                    ? 'No se ha seccionado fecha'
                    : fecha.toLocal().toIso8601String().split('T')[0];
              },
              child: const Text('Seleccionar fecha'),
            ),
            GUIEstandar.espacioEntreCampos,
            const Text('¿ASISTIO?'),
            GUIEstandar.espacioEntreCampos,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: GUIEstandar.estiloAceptarFormulario,
                    onPressed: () {
                      asistencia = true;
                      registrarOActualizar(context, app, registrar, a);
                    },
                    child: const Text("Sí", style: GUIEstandar.estiloTextoBoton,)),
                ElevatedButton(
                    style: GUIEstandar.estiloCancelarFormulario,
                    onPressed: () {
                      asistencia = false;
                      registrarOActualizar(context, app, registrar, a);
                    },
                    child: const Text("No", style: GUIEstandar.estiloTextoBoton,)),
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
        nhorario: nhorario,
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
    if (asistencia.isNotEmpty) {
      return ListView.builder(
        itemCount: asistencia.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
              child: Text(asistencia[index].idasistencia.toString())),
          title:
              Text(asistencia[index].nombre),
          subtitle: Text(
'''Fecha: ${asistencia[index].fecha} Hora: ${asistencia[index].hora}
Materia: ${asistencia[index].descripcion}
${asistencia[index].asistencia?'Asistió':'No Asistió'}
'''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, asistencia[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, asistencia[index]);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      return GUIEstandar.listaVacia('No hay Asistencias registradas');
    }
  }

  static void borrar(MyAppState app, Horario_Asistencia asistencia) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("Deseas eliminar la Asistencia?"),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                DBAsistencia.eliminar(asistencia.idasistencia).then((value) {
                  Navigator.pop(app.context);
                  app.consultarAsistencia();
                  app.mensaje("Asistencia eliminada con exito");
                });
              },
              child: const Text('Si'))
        ],
      ),
    );
  }
}
