import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hand_sign_cricket/themes/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  final bool userBatsFirst;

  GameScreen({required this.userBatsFirst});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int playerScore = 0;
  int botScore = 0;
  int wickets = 0;
  int balls = 0;
  int overs = 0;
  int target = 0;
  bool isFirstInnings = true;
  bool isPlayerBatting = true;
  String playerName = "Player";
  String botName = "Bot";
  List<String> overLog = [];
  final int maxOvers = 5;
  final int maxWickets = 2;

  @override
  void initState() {
    super.initState();
    isPlayerBatting = widget.userBatsFirst;
    _loadGameData();
  }

  Future<void> _loadGameData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      playerScore = prefs.getInt('playerScore') ?? 0;
      botScore = prefs.getInt('botScore') ?? 0;
      wickets = prefs.getInt('wickets') ?? 0;
      balls = prefs.getInt('balls') ?? 0;
      overs = prefs.getInt('overs') ?? 0;
      target = prefs.getInt('target') ?? 0;
      isFirstInnings = prefs.getBool('isFirstInnings') ?? true;
      isPlayerBatting =
          prefs.getBool('isPlayerBatting') ?? widget.userBatsFirst;
    });
  }

  void playBall(int shot) {
    int botShot = Random().nextInt(6) + 1;
    setState(() {
      if (isPlayerBatting) {
        if (shot == botShot) {
          wickets++;
          overLog.add("OUT");
        } else {
          playerScore += shot;
          overLog.add(shot.toString());
        }
      } else {
        if (shot == botShot) {
          wickets++;
          overLog.add("OUT");
        } else {
          botScore += botShot;
          overLog.add(botShot.toString());
        }
      }

      balls++;
      if (balls % 6 == 0) {
        overs++;
        overLog.clear();
      }

      if (isFirstInnings && (wickets == maxWickets || overs == maxOvers)) {
        _endInnings();
      } else if (!isFirstInnings &&
          (botScore >= target || wickets == maxWickets || overs == maxOvers)) {
        _endGame();
      }
    });
  }

  void _endInnings() {
    setState(() {
      isFirstInnings = false;
      target = isPlayerBatting ? playerScore + 1 : botScore + 1;
      wickets = 0;
      balls = 0;
      overs = 0;
      overLog.clear();
      isPlayerBatting = !isPlayerBatting;
    });
  }

  void _endGame() {
    String result = botScore >= target ? "Bot45 Wins!" : "Player18 Wins!";
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Match Over",
          style: TextStyle(
              color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        content: Text(result),
        actions: [
          TextButton(
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Player18",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 42,
                        color: Colors.purpleAccent),
                  ),
                  Text(
                    "VS",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                  Text(
                    "Bot45",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 42,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 5),
              ),
              child: Column(
                children: [
                  Text("SCOREBOARD",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w800)),
                  SizedBox(height: 10),
                  Text("$playerName: $playerScore",
                      style: TextStyle(fontSize: 24)),
                  Text("$botName: $botScore", style: TextStyle(fontSize: 24)),
                  Text("Wickets: $wickets / $maxWickets",
                      style: TextStyle(fontSize: 18)),
                  Text("Overs: $overs.${balls % 6} / $maxOvers",
                      style: TextStyle(fontSize: 18)),
                  if (!isFirstInnings)
                    Text("Target: $target",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 6,
              itemBuilder: (context, index) {
                int number = index + 1;
                return GestureDetector(
                  onTap: () => playBall(number),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.boxYellow,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 5),
                    ),
                    child: Image.asset('assets/gestures/$number.png',
                        fit: BoxFit.cover),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .yellowAccent, // Correct way to set the background color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back to Main Screen",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
