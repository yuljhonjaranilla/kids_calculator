import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(MathQuizApp());
}

class MathQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MathQuizScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MathQuizScreen extends StatefulWidget {
  @override
  _MathQuizScreenState createState() => _MathQuizScreenState();
}

class _MathQuizScreenState extends State<MathQuizScreen> {
  Random random = Random();
  late int num1, num2, answer;
  TextEditingController userInputController = TextEditingController();
  String operation = "";
  bool? isCorrect;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
    generateQuestion();
  }

  void generateQuestion() {
    num1 = random.nextInt(10) + 1;
    num2 = random.nextInt(10) + 1;

    // Randomly select an operation
    switch (random.nextInt(4)) {
      case 0:
        operation = "+";
        answer = num1 + num2;
        break;
      case 1:
        operation = "-";
        answer = num1 - num2;
        break;
      case 2:
        operation = "x";
        answer = num1 * num2;
        break;
      case 3:
      // Ensure non-zero divisor for division
        num2 = random.nextInt(9) + 1;
        operation = "÷";
        answer = (num1 / num2).truncate(); // Ensure integer result for division
        break;
    }
  }

  void checkAnswer() {
    int? userAnswer = int.tryParse(userInputController.text);

    setState(() {
      isCorrect = userAnswer == answer;
      if (isCorrect!) {
        _confettiController.play();
        showCongratulationsDialog();
        generateQuestion();
        userInputController.clear();
      }
    });
  }

  void showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 50,
                  color: Colors.green,
                ),
                SizedBox(height: 10),
                Text('Very Good!'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Math for Kids')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '$num1 $operation $num2 = ?',
                style: TextStyle(fontSize: 50),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: userInputController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(labelText: 'Your Answer'),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => checkAnswer(),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isCorrect != null)
              Text(
                isCorrect!
                    ? 'Correct! Keep going!'
                    : 'Incorrect!',
                style: TextStyle(
                  color: isCorrect! ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
            SizedBox(height: 20),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality:
              BlastDirectionality.explosive, // don't specify a direction, blast in all directions
              shouldLoop: false, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ], // manually specify the colors to be used
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
}
