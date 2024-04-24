import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBHorario.dart';
import 'package:dam_u3_practica1_checador_asistencia/GUI/GUIEstandar.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/Horario.dart';
import 'package:dam_u3_practica1_checador_asistencia/Modelo/HorarioConsultado.dart';
import 'package:dam_u3_practica1_checador_asistencia/main.dart';
import 'package:flutter/material.dart';

class GUIHorario {
  static String nmat = '';
  static String nprofesor = '';
  static final hora = TextEditingController();
  static final edificio = TextEditingController();
  static final salon = TextEditingController();

  static void formularioRegistrar(MyAppState app, bool registrar,
      [HorarioConsultado? h]) {
    if (h == null) {
      if (app.materias.isNotEmpty) {
        nmat = app.materias.first.nmat;
      }
      if (app.profesor.isNotEmpty) {
        nprofesor = app.profesor.first.nprofesor;
      }
    } else {
      nprofesor = h.nprofesor;
      nmat = h.nmat;
      edificio.text = h.edificio;
      hora.text = h.hora;
      salon.text = h.salon;
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
              '${registrar ? "Registrar un nuevo" : "Actualizar"} Horario',
              textAlign: TextAlign.center,
              style: GUIEstandar.estiloTextoBoton,
            ),
            GUIEstandar.espacioEntreCampos,
            const Text('Seleccionar profesor:'),
            DropdownButtonFormField(
              value: nprofesor,
              items: app.profesor
                  .map((e) => DropdownMenuItem(
                        value: e.nprofesor,
                        child: Text('${e.nprofesor} - ${e.nombre}'),
                      ))
                  .toList(),
              onChanged: (value) => nprofesor = value.toString(),
            ),
            GUIEstandar.espacioEntreCampos,
            const Text('Seleccionar materia:'),
            DropdownButtonFormField(
              value: nmat,
              items: app.materias
                  .map((e) => DropdownMenuItem(
                        value: e.nmat,
                        child: Text('${e.nmat} - ${e.descripcion}'),
                      ))
                  .toList(),
              onChanged: (value) => nmat = value.toString(),
            ),
            TextField(
              controller: hora,
              decoration: const InputDecoration(
                  labelText: 'HORA:', suffixIcon: Icon(Icons.watch)),
            ),
            GUIEstandar.espacioEntreCampos,
            TextField(
              controller: edificio,
              decoration: const InputDecoration(
                  labelText: 'EDIFICIO:',
                  suffixIcon: Icon(Icons.location_city)),
            ),
            GUIEstandar.espacioEntreCampos,
            TextField(
              controller: salon,
              decoration: const InputDecoration(
                  labelText: 'SALON:', suffixIcon: Icon(Icons.event_seat)),
            ),
            GUIEstandar.espacioEntreCampos,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: GUIEstandar.estiloCancelarFormulario,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: GUIEstandar.estiloTextoBoton,
                    )),
                ElevatedButton(
                    style: GUIEstandar.estiloAceptarFormulario,
                    onPressed: () {
                      finalizar() {
                        Navigator.pop(context);
                        app.consultarHorario();
                        for (var element in [hora, edificio, salon]) {
                          element.clear();
                        }
                        nmat = '';
                        nprofesor = '';
                      }

                      var m = Horario(
                          nhorario: h?.nhorario,
                          nprofesor: nprofesor,
                          nmat: nmat,
                          hora: hora.text,
                          edificio: edificio.text,
                          salon: salon.text);
                      registrar
                          ? DBHorario.registrar(m).then((value) {
                              finalizar();
                              app.consultarHorario();
                              app.mensaje('Horario registrado con exito');
                            })
                          : DBHorario.actualizar(m).then((value) {
                              finalizar();
                              app.consultarHorario();
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

  static Widget listaHorario(MyAppState app) {
    var horario = app.horario;
    if (horario.isNotEmpty) {
      return ListView.builder(
        itemCount: horario.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(child: Text('${horario[index].nhorario}')),
          title: Text("${horario[index].nombre}"),
          subtitle: Text(
              '''Materia:${horario[index].descripcion} Hora:${horario[index].hora}
Edificio:${horario[index].edificio} Salon:${horario[index].salon}'''),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, horario[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, horario[index]);
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else {
      return GUIEstandar.listaVacia('No hay horarios registrados');
    }
  }

  static void borrar(MyAppState app, HorarioConsultado horario) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar"),
        content: const Text("Deseas eliminar el horario?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                DBHorario.eliminar(horario.nhorario).then((value) {
                  Navigator.pop(app.context);
                  app.consultarHorario();
                  app.mensaje("Materia eliminada con exito");
                });
              },
              child: const Text('Si'))
        ],
      ),
    );
  }
}
