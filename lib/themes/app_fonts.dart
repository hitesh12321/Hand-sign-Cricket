import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // Press Start 2P Font (used for title)
  static TextStyle pressStart2p({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    required List<Shadow> shadows,
  }) {
    return GoogleFonts.pressStart2p(
      fontSize: fontSize,
      fontWeight: fontWeight,
      shadows: shadows,
      color: color,
    );
  }

  // Default Font (used for buttons and dialogs)
  static TextStyle main({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: 'Roboto', // Fallback font
    );
  }

  // Bebas Neue Font (if you still want to keep it)
  static TextStyle aDLaMDisplay({
    double fontSize = 40,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.aDLaMDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Permanent Marker Font (if you still want to keep it)
  static TextStyle permanentMarker({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.permanentMarker(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
