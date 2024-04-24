class Horario_Asistencia {
  int nhorario;
  String nprofesor;
  String nmat;

  //Horario
  String hora;
  String edificio;
  String salon;

  //Materia
  String descripcion;

  //Profesor
  String nombre;
  String carrera;

  //asistencia
  int idasistencia;
  String fecha;
  bool asistencia;

  Horario_Asistencia({
    required this.nhorario,
    required this.nprofesor,
    required this.nmat,
    required this.hora,
    required this.edificio,
    required this.salon,
    required this.descripcion,
    required this.nombre,
    required this.carrera,
    required this.asistencia,
    required this.fecha,
    required this.idasistencia
  });
}