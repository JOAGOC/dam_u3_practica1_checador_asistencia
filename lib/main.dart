import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp(),debugShowCheckedModeBanner: false
    ,));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _indice= 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CHECADOR",style: TextStyle(
          fontSize: 30,
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
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_sharp), label: "Materia" , backgroundColor: Colors.green),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: "Profesor" , backgroundColor: Colors.yellowAccent.shade700),
          BottomNavigationBarItem(icon: Icon(Icons.access_time_filled), label: "Horario" , backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered), label: "Asistencia" , backgroundColor: Colors.blue),
        ],
        currentIndex: _indice,
        onTap: (index){
          setState(() {
            _indice=index;

          });
        },
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
      ),
    );
  }

  dinamico() {}
}