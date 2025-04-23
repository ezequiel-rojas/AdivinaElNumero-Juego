import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el Número',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
      ),
      themeMode: ThemeMode.dark,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _numeroSecreto = 0;
  int _intentosRestantes = 5;
  int _numeroMaximo = 10;
  int _nivel = 1;  // 1 = Fácil, 2 = Medio, 3 = Avanzado, 4 = Extremo
  String _nivelString = 'Fácil';
  List<Tuple<int, Color>> _mayorQue = [];
  List<Tuple<int, Color>> _menorQue = [];
  List<Tuple<int, Color>> _historial = [];
  TextEditingController _controladorNumero = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adivina el Número'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Casilla para ingresar el numero
                Expanded(
                  child: TextField(
                    controller: _controladorNumero,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Ingresa un número',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)
                      )
                    ),
                    onSubmitted: (_) {
                      print('Numero ingresado'); // TODO: Llamar al metodo que verifica el numero ingresado
                    },
                  ),
                ),
                SizedBox(width: 16),
                // Contador de intentos restantes
                Text(
                  'Intentos restantes: $_intentosRestantes',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(height: 20),
            // Columnas de números mayores, menores e historial
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [Text('Mayor que')],), // TODO: Generar columnas correctamente
                SizedBox(width: 10),
                Column(children: [Text('Menor que')],),
                SizedBox(width: 10),
                Column(children: [Text('Historial')],),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(width: 20),
            Center(child: Text(_nivelString)),
            SizedBox(width: 20),
            // Barra de seleccion de dificultad
            Slider(
              value: _nivel.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              activeColor: Colors.blue,
              onChanged: (double value) {
                print('La dificultad cambió');  // TODO: Cambiar el nivel del juego
              },
            )
          ],
        )
      )
    );
  }
}

class Tuple<T, U> {
  final T item1;
  final U item2;

  Tuple(this.item1, this.item2);
}
