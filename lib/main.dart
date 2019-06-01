import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/splashScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'UNI-FOSS',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.red[800],
        accentColor: Colors.redAccent[600],

        // Define la Familia de fuente por defecto
        //fontFamily: 'Montserrat',

        // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
        // para cabeceras, títulos, cuerpos de texto, y más.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      initialRoute: '/splashScreen',
      routes: {
        // Cuando naveguemos hacia la ruta "/", crearemos el Widget FirstScreen
        '/': (context) => Home("Uni-Foss", "Home"),
        '/splashScreen': (context) => SplashScreen(),
        //'/': (context) => Pruebas("Uni-Foss", "Home"),

      },

    );
  }
}


