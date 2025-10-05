import 'package:flutter/material.dart';
import 'package:hand_sign_cricket/themes/app_colors.dart';

class Play {
  static void showHowToPlayDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "How to Play",
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 350,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.dialogYellow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'How to Play?',
                      style: TextStyle(
                        color: AppColors.dialogBlack,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRule('🎲 Toss Time:',
                              'Choose Odd or Even. Both players will also select a number.'),
                          _buildRule('🏏 Bat or Bowl:',
                              'If you win the toss, choose whether to bat or bowl.'),
                          _buildRule('✋ Hand Signs:',
                              'Show a number with your fingers (1-6). The opponent will also select a number.'),
                          _buildRule('⚡ Game Mechanics:',
                              'If the signs are the same, the batter is out! Otherwise, the batter scores runs based on their hand sign. The game continues until all wickets fall or the target is chased.'),
                          _buildRule('🏆 Winning Criteria:',
                              'The team with the highest score wins!'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dialogOrange,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            color: AppColors.buttonTextBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: anim1,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  static Widget _buildRule(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 18, color: Colors.black54),
          children: [
            TextSpan(
              text: title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: ' $description',
            ),
          ],
        ),
      ),
    );
  }
}
