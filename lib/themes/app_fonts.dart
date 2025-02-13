import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // Default Font (Roboto)
  static const String mainFont = "Roboto";

  // Bebas Neue Font
  static TextStyle bebasNeue(
      {double fontSize = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return GoogleFonts.bebasNeue(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Permanent Marker Font
  static TextStyle permanentMarker(
      {double fontSize = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return GoogleFonts.permanentMarker(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Main (Roboto) Font
  static TextStyle main(
      {double fontSize = 16,
      FontWeight fontWeight = FontWeight.normal,
      Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
