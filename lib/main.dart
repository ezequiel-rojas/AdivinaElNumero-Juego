import 'package:flutter/material.dart';
import 'dart:math';

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

  // Metodo que cambia la dificultad del juego
  void _cambiarDificultad(int nivel) {
    setState(() {
      _nivel = nivel;
      switch (nivel) {
        case 1:
          _numeroMaximo = 10;
          _intentosRestantes = 5;
          _nivelString = 'Fácil';
          break;
        case 2:
          _numeroMaximo = 20;
          _intentosRestantes = 8;
          _nivelString = 'Medio';
          break;
        case 3:
          _numeroMaximo = 100;
          _intentosRestantes = 15;
          _nivelString = 'Avanzado';
          break;
        case 4:
          _numeroMaximo = 1000;
          _intentosRestantes = 25;
          _nivelString = 'Extremo';
          break;
      }
      _numeroSecreto = Random().nextInt(_numeroMaximo) + 1; // 1 - numeroMaximo
      _mayorQue.clear();
      _menorQue.clear();
      _controladorNumero.clear();
    });
  }

  void _adivinarNumero() {
    int numero = int.tryParse(_controladorNumero.text) ?? - 1;
    
    if (numero <=0 || numero > _numeroMaximo) {
      _showError('Número fuera de rango. El número para este nivel es de 1 a $_numeroMaximo');
      return;
    }

    setState(() {
      _intentosRestantes--;

      // Comprobamos si se adivino el numero
      if (numero == _numeroSecreto) {
        _historial.add(Tuple(numero, Colors.green));
        _cambiarDificultad(_nivel);
      } else if (numero > _numeroSecreto) {
        _menorQue.add(Tuple(numero, Colors.white));
      } else {
        _mayorQue.add(Tuple(numero, Colors.white));
      }
      
      // Cuando no se adivino el numero
      if (_intentosRestantes <= 0) {
        _historial.add(Tuple(_numeroSecreto, Colors.red));
        _cambiarDificultad(_nivel);
      }
    });

    _controladorNumero.clear();
  }

  void _showError(String mensaje) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: Text('Aceptar')
          )
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _cambiarDificultad(_nivel);
  }

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
                      _adivinarNumero();
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
                _buildColumn('Mayor que', _mayorQue),
                SizedBox(width: 10),
                _buildColumn('Menor que', _menorQue),
                SizedBox(width: 10),
                _buildColumn('Historial', _historial),
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
                _cambiarDificultad(value.toInt());
              },
            )
          ],
        )
      )
    );
  }

  // Constructor de columnas de numeros
  Widget _buildColumn(String titulo, List<Tuple<int, Color>> lista) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          children: [
            Text(titulo),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: ListView(
                children: lista.map((tupla) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        '${tupla.item1}',
                        style: TextStyle(fontSize: 18, color: tupla.item2),
                      )
                    )
                  );
                }).toList(),
              ),
            )
          ],
        ),
      )
    );
  }
}

class Tuple<T, U> {
  final T item1;
  final U item2;

  Tuple(this.item1, this.item2);
}
