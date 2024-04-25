import 'package:flutter/material.dart';

class GUIEstandar {
  static final estiloCancelarFormulario = estiloFormulario(Colors.red);
  static final estiloAceptarFormulario = estiloFormulario(Colors.green);
  static const estiloTextoBoton = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const espacioEntreCampos = SizedBox(
    height: 20,
  );
  static const paddingFormulario = EdgeInsets.all(16);

  static ButtonStyle estiloFormulario(Color background) {
    return ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  static Center listaVacia(String mensaje) {
    return Center(
      child: Text(mensaje,
          style: TextStyle(color: Colors.black54)),
    );
  }
}
