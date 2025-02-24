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
      backgroundColor: Colors.yellowAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black, width: 3),
      ),
      title: Text(
        "Rate the Game",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Submit",
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
