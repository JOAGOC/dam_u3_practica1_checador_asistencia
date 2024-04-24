
import 'package:flutter/material.dart';

class GUIConsultarMateria extends StatefulWidget {
  const GUIConsultarMateria({super.key});

  @override
  State<GUIConsultarMateria> createState() => _GUIConsultarMateriaState();
}

class _GUIConsultarMateriaState extends State<GUIConsultarMateria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text(
        "Consultar materias de profesor",
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
        backgroundColor: Colors.blue,
      ),

    );
  }
}
