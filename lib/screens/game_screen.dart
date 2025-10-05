// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hand_sign_cricket/screens/menu_screen.dart';
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
  bool gameOver = false;
  bool _showOutGif = false;

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

  int botDecision(int userShot) {
    if (!isFirstInnings) {
      int runsNeeded = target - botScore;
      if (runsNeeded <= 6) return runsNeeded;
    }
    return Random().nextInt(6) + 1;
  }

  void playBall(int shot) {
    if (gameOver) return;
    int botShot = botDecision(shot);

    setState(() {
      if (isPlayerBatting) {
        if (shot == botShot) {
          wickets++;
          _showOutGif = true; // Show "out" GIF
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _showOutGif = false; // Hide GIF after delay
            });
          });
        } else {
          playerScore += shot;
        }
      } else {
        if (shot == botShot) {
          wickets++;
          _showOutGif = true;
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _showOutGif = false;
            });
          });
        } else {
          botScore += botShot;
        }
      }
      balls++;
      if (balls % 6 == 0) overs++;

      _checkGameState();
    });
  }

  void _checkGameState() {
    if (isFirstInnings && (wickets >= maxWickets || overs >= maxOvers)) {
      _endInnings();
    } else if (!isFirstInnings) {
      if (botScore >= target) {
        _endGame(false);
      } else if (playerScore >= target) {
        _endGame(true);
      } else if (wickets >= maxWickets || overs >= maxOvers) {
        _endGame(botScore < target);
      }
    }
  }

  void _endInnings() {
    setState(() {
      isFirstInnings = false;
      target = isPlayerBatting ? playerScore + 1 : botScore + 1;
      wickets = 0;
      balls = 0;
      overs = 0;
      isPlayerBatting = !isPlayerBatting;
    });
  }

  void _endGame(bool playerWon) {
    gameOver = true;
    String result = playerWon ? "🎉 You Win! 🎉" : "😢 Bot Wins! 😢";
    String gifPath = playerWon
        ? "assets/animation/win2.gif"
        : "assets/animation/lost2.gif"; // Choose GIF based on result

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.dialogYellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 3),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              " Match Over ",
              style: TextStyle(
                color: AppColors.titleOrange,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10), // Space between title and GIF
            Container(
              height: 120, // Adjust size as needed
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(gifPath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10), // Space between GIF and result text
          ],
        ),
        content: Text(
          result,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dialogOrange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Back to Main Menu",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 10), // Extra space at bottom for better UI
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 112, 174, 240),
      body: Stack(
        children: [
          Container(
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
                        "👦🏻\nYou",
                        style: GoogleFonts.bangers(
                          fontSize: 60,
                          color: Colors.black,
                          shadows: [
                            // Shadow(
                            //     blurRadius: 12.0,
                            //     color: Colors.deepPurple,
                            //     offset: Offset(4, 4)),
                            Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(1, 1)),
                          ],
                        ),
                      ),
                      Text(
                        "VS",
                        style: GoogleFonts.montserrat(
                          fontSize: 60,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 30.0,
                                color: Colors.grey,
                                offset: Offset(5, 4)),
                            // Shadow(
                            //     blurRadius: 3.0,
                            //     color: Colors.black,
                            //     offset: Offset(1, 1)),
                          ],
                        ),
                      ),
                      Text(
                        " 🤖 \nBot",
                        style: GoogleFonts.bangers(
                          fontSize: 60,
                          color: Colors.black,
                          shadows: [
                            Shadow(
                                blurRadius: 3.0,
                                color: Colors.black,
                                offset: Offset(1, 1)),
                            // Shadow(
                            //     blurRadius: 12.0,
                            //     color: Colors.redAccent,
                            //     offset: Offset(4, 4)),
                            // Shadow(
                            //     blurRadius: 3.0,
                            //     color: Colors.black,
                            //     offset: Offset(2, 2)),
                          ],
                        ),
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
                    color: const Color.fromARGB(255, 28, 138, 234),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 5),
                  ),
                  child: Column(
                    children: [
                      Text("SCOREBOARD",
                          style: GoogleFonts.pressStart2p(
                              fontSize: 37,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("You: $playerScore",
                          style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("Bot: $botScore",
                          style: GoogleFonts.montserrat(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("Wickets: $wickets / $maxWickets",
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text("Overs: $overs.${balls % 6} / $maxOvers",
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      if (!isFirstInnings)
                        Text("Target: $target",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      if (_showOutGif)
                        Container(
                          // Semi-transparent background
                          child: Center(
                            child: Image.asset(
                              'assets/animation/wickets.gif',
                              width: 100, // Adjust size as needed
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
