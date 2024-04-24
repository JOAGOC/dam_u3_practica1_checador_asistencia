import 'package:flutter/material.dart';

class GUIConsultarAsistencia extends StatefulWidget {
  const GUIConsultarAsistencia({super.key});

  @override
  State<GUIConsultarAsistencia> createState() => _GUIConsultarAsistenciaState();
}

class _GUIConsultarAsistenciaState extends State<GUIConsultarAsistencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Consultar Asistencias de profesor",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Colors.white,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.amber,
      ),

    );
  }
}
