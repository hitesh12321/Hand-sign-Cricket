import 'package:flutter/material.dart';

class RatingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rate the Game"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5,
            (index) => Icon(Icons.star_border, size: 30, color: Colors.amber)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Submit"),
        ),
      ],
    );
  }
}
