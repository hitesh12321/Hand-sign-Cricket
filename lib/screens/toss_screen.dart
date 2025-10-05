import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hand_sign_cricket/themes/app_colors.dart';
import 'package:hand_sign_cricket/themes/app_fonts.dart';

import 'game_screen.dart';

class TossScreen extends StatefulWidget {
  @override
  _TossScreenState createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> {
  String? userChoice;
  int? userNumber;
  int botNumber = Random().nextInt(6) + 1;
  String tossResult = "";
  bool userWonToss = false;
  bool tossDone = false;
  String botDecision = "";
  bool isTossing = false;
  String animationAsset = "";

  void performToss() {
    setState(() {
      isTossing = true;
      animationAsset = 'assets/animation/coin-flip.gif';
    });

    Future.delayed(const Duration(seconds: 3), () {
      int sum = userNumber! + botNumber;
      bool isEven = sum % 2 == 0;
      bool userChoseEven = userChoice == "Even";

      setState(() {
        tossDone = true;
        isTossing = false;
        if ((isEven && userChoseEven) || (!isEven && !userChoseEven)) {
          tossResult = "🎉 Yay! You won!";
          userWonToss = true;

          animationAsset = 'assets/animation/tosswin2.gif';
        } else {
          tossResult = "😞 Bad luck! You lost!";
          userWonToss = false;
          botDecision = Random().nextBool() ? "Bat" : "Bowl";
          animationAsset = 'assets/animation/lost2.gif';
          Future.delayed(const Duration(seconds: 2), () {
            navigateToGame(botDecision);
          });
        }
      });
    });
  }

  void navigateToGame(String choice) {
    bool userBatsFirst =
        userWonToss ? (choice == "Bat") : (botDecision == "Bowl");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(userBatsFirst: userBatsFirst),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 121, 178, 239),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isTossing || tossDone) Image.asset(animationAsset, height: 180),
            if (tossDone) ...[
              Text(
                tossResult,
                style: AppFonts.aDLaMDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const SizedBox(height: 20),
              if (userWonToss) ...[
                const Text("Choose Bat or Bowl",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ["Bat", "Bowl"]
                      .map((e) => ElevatedButton(
                            onPressed: () => navigateToGame(e),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.boxYellow,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              elevation: 10,
                            ),
                            child: Text(e,
                                style: AppFonts.aDLaMDisplay(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ))
                      .toList(),
                ),
              ] else ...[
                Text("Bot chose to $botDecision",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ],
            if (!isTossing && !tossDone) ...[
              Text("Choose Odd or Even", style: AppFonts.aDLaMDisplay()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ["Odd", "Even"].map((e) {
                  return GestureDetector(
                    onTap: () => setState(() => userChoice = e),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        color: userChoice == e
                            ? AppColors.boxYellow
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Text(e,
                          style: AppFonts.aDLaMDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  );
                }).toList(),
              ),
              if (userChoice != null) ...[
                const SizedBox(height: 20),
                Text("Select a number (1-6)",
                    style: GoogleFonts.aDLaMDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() => userNumber = index + 1),
                      child: Container(
                        decoration: BoxDecoration(
                          border: userNumber == index + 1
                              ? Border.all(
                                  color: AppColors.dialogOrange, width: 5)
                              : Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset('assets/gestures/${index + 1}.png',
                              fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: performToss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.boxYellow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 12,
                  ),
                  child: Text("Toss",
                      style: AppFonts.aDLaMDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
