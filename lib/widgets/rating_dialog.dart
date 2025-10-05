import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 121, 178, 239),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 3),
      ),
      title: const Text(
        "Rate the Game",
        style: TextStyle(
            color: const Color.fromARGB(255, 3, 25, 48),
            fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return IconButton(
            icon: Icon(
              index < selectedRating ? Icons.star : Icons.star_border,
              color: index < selectedRating ? Colors.red : Colors.black,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                selectedRating = index + 1;
              });
            },
          );
        }),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 19, 127, 242),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Submit",
            style: TextStyle(
                color: const Color.fromARGB(255, 3, 25, 48),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
