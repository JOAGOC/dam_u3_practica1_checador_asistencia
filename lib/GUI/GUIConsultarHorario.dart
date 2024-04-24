import 'package:flutter/material.dart';

class GUIConsultarHorario extends StatefulWidget {
  const GUIConsultarHorario({super.key});

  @override
  State<GUIConsultarHorario> createState() => _GUIConsultarHorarioState();
}

class _GUIConsultarHorarioState extends State<GUIConsultarHorario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Consultar Horarios de Edificio",
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
        backgroundColor: Colors.red,
      ),

    );
  }
}
