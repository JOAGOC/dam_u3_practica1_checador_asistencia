class Asistencia{
  int? idasistencia;
  int nhorario;
  String fecha;
  bool asistencia;

  Asistencia({
    this.idasistencia,
    required this.nhorario,
    required this.fecha,
    required this.asistencia
  });

  Map<String,dynamic> toJSON(){
    return {
      'IDASISTENCIA':idasistencia,
      'NHORARIO':nhorario,
      'FECHA':fecha,
      'ASISTENCIA':asistencia,
    };
  }
}