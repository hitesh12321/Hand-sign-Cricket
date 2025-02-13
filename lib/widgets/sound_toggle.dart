import 'package:flutter/material.dart';

class SoundToggleButton extends StatefulWidget {
  @override
  _SoundToggleButtonState createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends State<SoundToggleButton> {
  bool isSoundOn = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isSoundOn ? Icons.volume_up : Icons.volume_off,
          color: Colors.grey, size: 30),
      onPressed: () {
        setState(() {
          isSoundOn = !isSoundOn;
        });
        // Implement sound logic later
      },
    );
  }
}
