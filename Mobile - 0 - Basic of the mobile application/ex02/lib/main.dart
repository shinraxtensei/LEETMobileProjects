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
  final List<List<String>> _buttonRowsPortrait = [
    ['AC', 'C', '%', '/'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['.', '0', '=', 'x']
  ];

  final List<List<String>> _buttonRowsLandscape = [
    ['AC', '7', '4', '1', '.'],
    ['C', '8', '5', '2', '0'],
    ['%', '9', '6', '3', '='],
    ['/', 'x', '-', '+', 'x']
  ];

  late List<List<String>> _buttonRows;

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

      if (_isNumber(buttonText) ||
          buttonText == '=' ||
          buttonText == 'C' ||
          buttonText == 'AC') {
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

  // ignore: unused_element
  void _onButtonPressed(String buttonText) {
    debugPrint('Button pressed: $buttonText');
    _parseInput(buttonText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B5EFC),
        title: const Text('asd'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          debugPrint('Max Width: ${constraints.maxWidth}');
          debugPrint('Max Height: ${constraints.maxHeight}');
          // ignore: unused_local_variable
          double buttonFontSize = constraints.maxWidth * 0.06;
          double displayFontSize = constraints.maxWidth * 0.05;
          // ignore: unused_local_variable
          double buttonPadding = constraints.maxWidth * 0.003;

          if (constraints.maxWidth > constraints.maxHeight) {
            _buttonRows = _buttonRowsLandscape;
          } else {
            _buttonRows = _buttonRowsPortrait;
          }

          return SingleChildScrollView(
            child: Center(
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
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.05),
                            child: Text(
                              clickedEqual
                                  ? resultText.toString()
                                  : displayText.toString(),
                              style: TextStyle(fontSize: displayFontSize),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constraints.maxWidth * 0.05),
                            child: Text(
                              clickedEqual
                                  ? ''
                                  : resultText.toString() == '0'
                                      ? ''
                                      : resultText.toString(),
                              style: TextStyle(
                                  fontSize: displayFontSize,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //number pad
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(constraints.maxWidth * 0.1),
                        topRight: Radius.circular(constraints.maxWidth * 0.1),
                      ),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      // shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _buttonRows[0].length,
                      ),
                      itemCount: _buttonRows.length * _buttonRows[0].length,
                      itemBuilder: (context, index) {
                        final row = index ~/ _buttonRows[0].length;
                        final col = index % _buttonRows[0].length;

                        // Check if current button is an operator
                        // ignore: unused_local_variable
                        final isOperator = col == _buttonRows[0].length - 1;

                        // Check if current button is in the first row or last column
                        // ignore: unused_local_variable
                        final isFirstRow = row == 0;
                        // ignore: unused_local_variable
                        final isLastColumn = col == _buttonRows[0].length - 1;

                        return const Placeholder(
                          strokeWidth: 0,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
