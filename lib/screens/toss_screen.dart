import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hand_sign_cricket/themes/app_colors.dart'; // Import your AppColors
import 'package:hand_sign_cricket/themes/app_fonts.dart'; // Import your AppFonts

import 'game_screen.dart';

class TossScreen extends StatefulWidget {
  @override
  _TossScreenState createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> {
  String? userChoice;
  int? userNumber;
  int botNumber = Random().nextInt(6) + 1; // Bot selects 1-6
  String tossResult = "";
  bool userWonToss = false;
  bool tossDone = false;

  void performToss() {
    int sum = userNumber! + botNumber;
    bool isEven = sum % 2 == 0;
    bool userChoseEven = userChoice == "Even";

    setState(() {
      tossDone = true;
      if ((isEven && userChoseEven) || (!isEven && !userChoseEven)) {
        tossResult = "🎉 You won the toss!";
        userWonToss = true;
      } else {
        tossResult = "😞 You lost the toss!";
        userWonToss = false;
      }
    });

    // If bot wins, it decides randomly
    if (!userWonToss) {
      Future.delayed(const Duration(seconds: 2), () {
        String botDecision = Random().nextBool() ? "Bat" : "Bowl";
        navigateToGame(botDecision);
      });
    }
  }

  void navigateToGame(String choice) {
    bool userBatsFirst;

    if (userWonToss) {
      userBatsFirst = (choice == "Bat");
    } else {
      userBatsFirst = (choice == "Bowl"); // Bot's decision is already random
    }

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
      backgroundColor: AppColors.backgroundBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title box
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 14),
            margin: const EdgeInsets.symmetric(horizontal: 100),
            decoration: BoxDecoration(
              color: AppColors.boxYellow,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: AppColors.shadowBlack,
                  offset: Offset(8, 9),
                ),
              ],
            ),
            child: Text(
              "TOSS",
              style: AppFonts.bebasNeue(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Toss options
          const Text(
            "Choose Odd or Even",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          // Odd or Even Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ["Odd", "Even"].map((e) {
              return GestureDetector(
                onTap: () => setState(() => userChoice = e),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: userChoice == e ? Colors.white : AppColors.boxYellow,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: AppColors.shadowBlack,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    e,
                    style: AppFonts.bebasNeue(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // Number selection if a choice is made
          if (userChoice != null) ...[
            const SizedBox(height: 20),
            const Text(
              "Select a number (1-6)",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // GridView for number selection
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => userNumber = index + 1),
                  child: Container(
                    decoration: BoxDecoration(
                      border: userNumber == index + 1
                          ? Border.all(color: Colors.yellowAccent, width: 8)
                          : null, // Highlight selected number
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 8,
                      child: Image.asset(
                        'assets/gestures/${index + 1}.png',
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          // Toss button if number is selected
          if (userNumber != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: performToss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.boxYellow,
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                elevation: 10,
              ),
              child: Text(
                "Toss",
                style: AppFonts.bebasNeue(
                  fontSize: 20,
                ),
              ),
            ),
          ],

          // Result & Animation Section
          if (tossDone) ...[
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(seconds: 2),
              child: Column(
                key: ValueKey(tossResult),
                children: [
                  Text(
                    tossResult,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          userWonToss ? Colors.purpleAccent : AppColors.textRed,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Bot chose: $botNumber",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            if (userWonToss)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["Bat", "Bowl"].map((e) {
                  return ElevatedButton(
                    onPressed: () => navigateToGame(e),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.boxYellow,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      elevation: 15,
                    ),
                    child: Text(
                      e,
                      style: AppFonts.bebasNeue(
                        fontSize: 18,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ],
      ),
    );
  }
}
