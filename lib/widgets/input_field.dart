import 'package:flutter/material.dart';

class AnimatedScaleButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData icon;
  final Animation<double> scaleAnimation;

  const AnimatedScaleButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
