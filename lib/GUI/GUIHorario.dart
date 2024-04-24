import 'package:dam_u3_practica1_checador_asistencia/Controlador/DBHorario.dart';
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
          padding: EdgeInsets.all(16),
          children: [
            Text('${registrar ? "Registrar un nuevo" : "Actualizar"} Horario',
                textAlign: TextAlign.center),
            SizedBox(
              height: 16,
            ),
            Text('Seleccionar profesor:'),
            DropdownButtonFormField(
              value: nprofesor,
              items: app.profesor
                  .map((e) => DropdownMenuItem(
                        child: Text('${e.nprofesor} -> ${e.nombre}'),
                        value: e.nprofesor,
                      ))
                  .toList(),
              onChanged: (value) => nprofesor = value.toString(),
            ),
            SizedBox(
              height: 16,
            ),
            Text('Seleccionar materia:'),
            DropdownButtonFormField(
              value: nmat,
              items: app.materias
                  .map((e) => DropdownMenuItem(
                        child: Text('${e.nmat} -> ${e.descripcion}'),
                        value: e.nmat,
                      ))
                  .toList(),
              onChanged: (value) => nmat = value.toString(),
            ),
            TextField(
              controller: hora,
              decoration: InputDecoration(
                  labelText: 'HORA:', suffixIcon: Icon(Icons.watch)),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: edificio,
              decoration: InputDecoration(
                  labelText: 'EDIFICIO:',
                  suffixIcon: Icon(Icons.location_city)),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: salon,
              decoration: InputDecoration(
                  labelText: 'SALON:', suffixIcon: Icon(Icons.event_seat)),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
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
                child: Text(registrar ? 'Registrar' : 'Actualizar'))
          ],
        ),
      ),
    );
  }

  static Widget listaHorario(MyAppState app) {
    var horario = app.horario;
    if (horario.length > 0) {
      return ListView.builder(
        itemCount: horario.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () => detalleHorario(app, horario[index]),
          leading: CircleAvatar(child: Text('${horario[index].nhorario}')),
          title:
              Text("${horario[index].nombre} -> ${horario[index].descripcion}"),
          subtitle:
              Text('${horario[index].hora} -> ${horario[index].edificio}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: Icon(Icons.mode),
                  onPressed: () {
                    formularioRegistrar(app, false, horario[index]);
                  }),
              IconButton(
                  onPressed: () {
                    borrar(app, horario[index]);
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
        ),
      );
    } else
      return Center(
        child: Text('No hay horarios registrados',
            style: TextStyle(color: Colors.black54)),
      );
  }

  static void borrar(MyAppState app, HorarioConsultado horario) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar"),
        content: Text("Deseas eliminar el horario?"),
        actions: [
          TextButton(
              onPressed: () {
                DBHorario.eliminar(horario.nhorario).then((value) {
                  Navigator.pop(app.context);
                  app.consultarHorario();
                  app.mensaje("Materia eliminada con exito");
                });
              },
              child: Text('Si'))
        ],
      ),
    );
  }

  static detalleHorario(MyAppState app, HorarioConsultado horario) {
    showDialog(
      context: app.context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cerrar'))
        ],
        title: Text('Horario ${horario.nhorario}'),
        content: Text('''
      Profesor: ${horario.nombre}
      Materia: ${horario.descripcion}
      Edificio: ${horario.edificio}
      Salon: ${horario.salon}
      Hora: ${horario.hora}     
      '''),
      ),
    );
  }
}
