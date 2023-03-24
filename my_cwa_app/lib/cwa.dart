import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double?> examScores = [];
  List<int> creditHours = [];
  double? totalScore;
  double? cwa;
  String? cwaClass;

  void clearData() {
    setState(
      () {
        examScores = [];
        creditHours = [];
        totalScore = null;
        cwa = null;
        cwaClass = null;
        _coursesController.clear();
      },
    );
  }

  void _calculateCwa() {
    setState(
      () {
        if (examScores.isEmpty ||
            creditHours.isEmpty ||
            examScores.length != creditHours.length ||
            examScores.contains(null) ||
            creditHours.contains(0)) {
          totalScore = null;
          cwa = null;
          return;
        }
        int totalCredits = creditHours.reduce((a, b) => a + b);
        double runningTotal = 0;
        for (int i = 0; i < examScores.length; i++) {
          if (examScores[i] != null) {
            runningTotal += examScores[i]! * creditHours[i];
          }
        }
        totalScore = runningTotal;
        cwa = totalScore! / totalCredits;
        if (cwa! >= 70) {
          cwaClass = "1st class";
        } else if (cwa! >= 60) {
          cwaClass = "2nd class upper onua";
        } else if (cwa! >= 50) {
          cwaClass = "2nd class lower onua";
        } else if (cwa! >= 40) {
          cwaClass = "Pass";
        } else if (cwa! >= 0) {
          cwaClass = "Fail";
        } else {
          cwaClass = "Not available";
        }
      },
    );
  }

  final TextEditingController _coursesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CWA Calculator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('How many courses do you study?'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _coursesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total courses',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(
                        () {
                          examScores = [];
                          creditHours = [];
                          examScores = List<double?>.filled(
                              int.tryParse(value) ?? 0, null);
                          creditHours =
                              List<int>.filled(int.tryParse(value) ?? 0, 0);
                        },
                      );
                    },
                  ),
                ),
                for (var i = 0; i < examScores.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Course ${i + 1} marks',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              examScores[i] = double.tryParse(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Course ${i + 1} credit hours',
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              creditHours[i] = int.tryParse(value) ?? 0;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                  ),
                  onPressed: () {
                    setState(
                      () {
                        _calculateCwa();
                      },
                    );
                  },
                  child: const Text('Calculate CWA'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        clearData();
                      },
                    );
                  },
                  child: const Text('Clear'),
                ),
                if (cwa != null) ...[
                  const SizedBox(height: 16.0),
                  Text(
                    'Your total score is ${totalScore!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Your CWA is ${cwa!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Congratulations, you had $cwaClass.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
