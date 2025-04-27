import 'package:flutter/material.dart';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E2A38),
      ),
      home: StartScreen(),
    );
  }
}

// ------------------ Start Screen ------------------
class StartScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's Play\nকুইজ",  // Changed to Bengali text
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Text("Enter your information below", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Colors.white54),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => QuizScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Start", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ Quiz Screen ------------------
class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;

  final List<Question> questions = [
    Question("What is the capital of France?", ["Paris", "London", "Rome", "Berlin"], 0),
    Question("Which planet is known as the Red Planet?", ["Earth", "Mars", "Jupiter", "Venus"], 1),
    Question("Who wrote 'Macbeth'?", ["Chaucer", "Shakespeare", "Dickens", "Rowling"], 1),
    Question("What is the square root of 64?", ["6", "7", "8", "9"], 2),
    Question("Which element has the symbol O?", ["Gold", "Oxygen", "Silver", "Iron"], 1),
    Question("In which continent is Egypt?", ["Africa", "Asia", "Europe", "America"], 0),
    Question("Which gas do plants absorb?", ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"], 1),
    Question("Who painted the Mona Lisa?", ["Van Gogh", "Da Vinci", "Picasso", "Rembrandt"], 1),
    Question("What is the chemical formula for water?", ["H2O", "CO2", "NaCl", "O2"], 0),
    Question("How many continents are there?", ["5", "6", "7", "8"], 2),
  ];

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctIndex) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FinalScoreScreen(score: score, total: questions.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question ${currentQuestionIndex + 1}/${questions.length}",
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            SizedBox(height: 20),
            Text(
              question.question,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(question.options[index], style: TextStyle(fontSize: 16)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ------------------ Final Score Screen ------------------
class FinalScoreScreen extends StatelessWidget {
  final int score;
  final int total;

  const FinalScoreScreen({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    double percent = score / total;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Final Score", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 40),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 12,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                    ),
                  ),
                  Text("$score/$total",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              Text("Correct Answers", style: TextStyle(color: Colors.white70, fontSize: 18)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Try Again", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ Question Model ------------------
class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question(this.question, this.options, this.correctIndex);
}
