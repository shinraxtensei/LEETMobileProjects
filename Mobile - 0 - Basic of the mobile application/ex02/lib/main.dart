import 'package:eval_ex/expression.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import math formd

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          primary: Color(0xFFED0E98),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF4B5EFC),
          onSecondary: Color(0xFFFFFFFF),
          background: Color(0xFF27292E),
          onBackground: Color(0xFF000000),
          surface: Color(0xFF333438),
          onSurface: Color(0xFFFFFFFF),
          error: Color(0xFFD32F2F),
          onError: Color(0xFFFFFFFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<List<String>> _buttonRows = [
    ['AC', 'C', '%', '/'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['.', '0', '=', 'x']
  ];

  String displayText = '';
  String resultText = '';
  bool clickedEqual = false;

  void _parseInput(String buttonText) {
    setState(() {
      if (clickedEqual) {
        displayText = '';
        resultText = '';
        clickedEqual = false;
      }
      debugPrint('is Number: $buttonText');

      if (_isNumber(buttonText)) {
        displayText += buttonText;
      } else if (_isOperator(buttonText)) {
        if (displayText.isEmpty && buttonText != '-') {
          _showToast('Invalid input');
          return;
        }
        if (buttonText == 'x') buttonText = '*';
        if (displayText.isNotEmpty &&
            _isOperator(displayText[displayText.length - 1])) {
          displayText = displayText.substring(0, displayText.length - 1);
        } else {
          displayText += buttonText;
        }
      } else if (buttonText == 'AC') {
        resultText = '';
        displayText = '';
      } else if (buttonText == 'C' && displayText.isNotEmpty) {
        displayText = displayText.substring(0, displayText.length - 1);
        resultText = '';
      } else if (buttonText == '%') {
        displayText += '%';
      } else if (buttonText == '.') {
        displayText += '.';
      }

      if (_isNumber(buttonText) || buttonText == '=' || buttonText == 'C' || buttonText == 'AC') {
      if (buttonText == '=') clickedEqual = true;

      _calculateResult();
      }
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _calculateResult() {
    setState(() {
      try {
        Expression exp = Expression(displayText);
        resultText = exp.eval().toString();
        debugPrint(exp.eval().toString());
      } catch (e) {
        debugPrint('Error: $e');
      }
    });
  }

  bool _isNumber(String text) {
    return double.tryParse(text) != null && !text.contains('.');
  }

  bool _isOperator(String text) {
    return text == '+' || text == '-' || text == 'x' || text == '/';
  }

  void _onButtonPressed(String buttonText) {
    debugPrint('Button pressed: $buttonText');
    _parseInput(buttonText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B5EFC),
        title: const Text('Calculator'),
      ),
      body: Center(
          //calculator
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //another column for the display
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 2000),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      clickedEqual
                          ? resultText.toString()
                          : displayText.toString(),
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      clickedEqual
                          ? ''
                          : resultText.toString() == '0'
                              ? ''
                              : resultText.toString(),
                      style: const TextStyle(fontSize: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //number pad
          Container(
            padding: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              // color 0xFF27292E
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 20,
              ),
              itemCount: _buttonRows.length * _buttonRows[0].length,
              itemBuilder: (context, index) {
                final row = index ~/ _buttonRows[0].length;
                final col = index % _buttonRows[0].length;

                // Check if current button is an operator
                final isOperator = col == _buttonRows[0].length - 1;

                // Check if current button is in the first row or last column
                final isFirstRow = row == 0;
                final isLastColumn = col == _buttonRows[0].length - 1;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFirstRow || isLastColumn
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.background,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () => _onButtonPressed(_buttonRows[row][col]),
                  child: Text(
                    _buttonRows[row][col],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: isOperator ? 30 : 20,
                      fontWeight:
                          isOperator ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
