import 'package:flutter/material.dart';

class play {
  static void showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 3),
          ),
          title: Text(
            'How to Play?',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
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
